import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/formatters.dart';
import 'avia_repository.dart';
import 'flight.dart';
import 'flight_route.dart';

/// Production backend: Firebase Realtime Database, Auth and Cloud Messaging.
///
/// A day is stored as a dense JSON array under `d-m-yyyy`. Older app versions
/// read it with `List.from(snapshot.value)`, so writes keep it an array.
///
/// Push notifications about new and changed flights must be sent by the server
/// (e.g. a Cloud Function on writes to the database): the legacy FCM HTTP API
/// that the app used to call directly was shut down by Google in 2024.
class FirebaseAviaRepository implements AviaRepository {
  FirebaseAviaRepository({
    FirebaseDatabase? database,
    FirebaseAuth? auth,
    FirebaseMessaging? messaging,
  }) : _database = database ?? FirebaseDatabase.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseDatabase _database;
  final FirebaseAuth _auth;
  final FirebaseMessaging _messaging;

  static const _writeTimeout = Duration(seconds: 10);

  DatabaseReference _day(DateTime date) => _database.ref(dbDateKey(date));

  @override
  Stream<List<Flight>> watchFlights(DateTime date) =>
      _day(date).onValue.map((event) => _parseDay(event.snapshot.value));

  static List<Flight> _parseDay(Object? value) {
    final Iterable<Object?> rows = switch (value) {
      final List<Object?> list => list,
      final Map<Object?, Object?> map =>
        (map.entries.toList()..sort(
              (a, b) => (int.tryParse('${a.key}') ?? 0).compareTo(
                int.tryParse('${b.key}') ?? 0,
              ),
            ))
            .map((e) => e.value),
      _ => const [],
    };
    return rows.whereType<Map<Object?, Object?>>().map(Flight.fromMap).toList();
  }

  @override
  Future<void> addFlight(DateTime date, Flight flight) => _write(
    () => _day(date).runTransaction((value) {
      return Transaction.success([
        ..._parseDay(value).map((f) => f.toMap()),
        flight.toMap(),
      ]);
    }),
  );

  @override
  Future<void> updateFlight(DateTime date, int index, Flight flight) =>
      _write(() => _day(date).child('$index').set(flight.toMap()));

  @override
  Future<void> deleteFlight(DateTime date, int index) => _write(
    () => _day(date).runTransaction((value) {
      final flights = _parseDay(value);
      if (index >= flights.length) return Transaction.abort();
      flights.removeAt(index);
      // An empty day is removed, which older versions show as "no flights".
      return Transaction.success(
        flights.isEmpty ? null : flights.map((f) => f.toMap()).toList(),
      );
    }),
  );

  /// The database queues writes while offline and never fails them, so the
  /// connection is checked up front to give the dispatcher immediate feedback.
  Future<void> _write(Future<Object?> Function() write) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.every((c) => c == ConnectivityResult.none)) {
      throw const RepositoryException(RepositoryError.network);
    }
    try {
      await write().timeout(_writeTimeout);
    } on TimeoutException {
      throw const RepositoryException(RepositoryError.network);
    } on FirebaseException {
      throw const RepositoryException(RepositoryError.unknown);
    }
  }

  @override
  Stream<String?> watchUser() => _auth.authStateChanges().map((u) => u?.email);

  @override
  String? get currentUser => _auth.currentUser?.email;

  @override
  Future<void> signIn(String email, String password) => _authCall(
    () => _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    ),
  );

  @override
  Future<void> signOut() => _authCall(_auth.signOut);

  @override
  Future<void> resetPassword(String email) =>
      _authCall(() => _auth.sendPasswordResetEmail(email: email.trim()));

  Future<void> _authCall(Future<Object?> Function() call) async {
    try {
      await call();
    } on FirebaseAuthException catch (e) {
      throw RepositoryException(switch (e.code) {
        'invalid-email' ||
        'wrong-password' ||
        'invalid-credential' ||
        'invalid-login-credentials' => RepositoryError.wrongCredentials,
        'user-not-found' => RepositoryError.userNotFound,
        'network-request-failed' => RepositoryError.network,
        'too-many-requests' => RepositoryError.tooManyRequests,
        _ => RepositoryError.unknown,
      });
    }
  }

  @override
  Future<void> setRouteNotifications(FlightRoute route, bool enabled) async {
    if (route.topic.isEmpty) {
      throw const RepositoryException(RepositoryError.unknown);
    }
    try {
      if (enabled) {
        await _messaging.requestPermission();
        await _messaging.subscribeToTopic(route.topic).timeout(_writeTimeout);
      } else {
        await _messaging
            .unsubscribeFromTopic(route.topic)
            .timeout(_writeTimeout);
      }
    } on TimeoutException {
      throw const RepositoryException(RepositoryError.network);
    } on FirebaseException {
      throw const RepositoryException(RepositoryError.unknown);
    }
  }
}
