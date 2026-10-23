import 'dart:async';

import '../utils/formatters.dart';
import 'avia_repository.dart';
import 'flight.dart';
import 'flight_route.dart';

/// In-memory backend with a sample schedule around [today]. Any email and
/// password sign in; writes are kept until the app is restarted.
class DemoAviaRepository implements AviaRepository {
  DemoAviaRepository({
    DateTime? today,
    String? signedInAs,
    this.latency = const Duration(milliseconds: 450),
  }) : _user = signedInAs {
    final day = dateOnly(today ?? DateTime.now());
    _days.addAll({
      dbDateKey(day.subtract(const Duration(days: 1))): _yesterday,
      dbDateKey(day): _today,
      dbDateKey(day.add(const Duration(days: 1))): _tomorrow,
      dbDateKey(day.add(const Duration(days: 2))): _afterTomorrow,
    });
  }

  final Duration latency;

  final _days = <String, List<Flight>>{};
  final _changes = StreamController<void>.broadcast();
  final _userChanges = StreamController<String?>.broadcast();
  String? _user;

  static const _polar = 'Полярные авиалинии';
  static const _yakutia = 'Якутия';

  static const _yesterday = [
    Flight(
      name: 'Тикси - Якутск',
      company: _yakutia,
      departure: '07:30',
      arrival: '10:05',
      status: 'Прибыл',
    ),
    Flight(
      name: 'Тикси - Булун',
      company: _polar,
      departure: '10:00',
      arrival: '11:10',
      status: 'Прибыл',
    ),
    Flight(
      name: 'Булун - Тикси',
      company: _polar,
      departure: '12:30',
      arrival: '13:40',
      status: 'Прибыл',
    ),
    Flight(
      name: 'Якутск - Тикси',
      company: _yakutia,
      departure: '11:20',
      arrival: '14:00',
      status: 'Прибыл',
    ),
    Flight(
      name: 'Тикси - Кюсюр',
      company: _polar,
      departure: '15:00',
      arrival: '16:20',
      status: 'Отменён',
    ),
  ];

  static const _today = [
    Flight(
      name: 'Тикси - Якутск',
      company: _yakutia,
      departure: '07:30',
      arrival: '10:05',
      status: 'Прибыл',
    ),
    Flight(
      name: 'Тикси - Кюсюр',
      company: _polar,
      departure: '09:00',
      arrival: '10:20',
      status: 'Вылетел',
    ),
    Flight(
      name: 'Якутск - Тикси',
      company: _yakutia,
      departure: '11:20',
      arrival: '14:00',
      status: 'В пути',
    ),
    Flight(
      name: 'Тикси - Булун-Сиктях',
      company: _polar,
      departure: '10:30',
      arrival: '13:10',
      status: 'Идёт посадка',
    ),
    Flight(
      name: 'Тикси - Борогон-Хара-Улах',
      company: _polar,
      departure: '12:40',
      arrival: '15:30',
      status: 'Задержан до 13:30',
    ),
    Flight(
      name: 'Тикси - Таймылыр',
      company: _polar,
      departure: '14:15',
      arrival: '16:05',
      status: 'Регистрация',
    ),
    Flight(
      name: 'Тикси - Москва',
      company: _yakutia,
      departure: '16:50',
      arrival: '19:35',
      status: 'По расписанию',
    ),
    Flight(
      name: 'Тикси - Сиктях',
      company: _polar,
      departure: '17:30',
      arrival: '19:00',
      status: 'Отменён: метеоусловия',
    ),
  ];

  static const _tomorrow = [
    Flight(
      name: 'Тикси - Якутск',
      company: _yakutia,
      departure: '07:30',
      arrival: '10:05',
      status: 'По расписанию',
    ),
    Flight(
      name: 'Тикси - Булун',
      company: _polar,
      departure: '10:00',
      arrival: '11:10',
      status: 'По расписанию',
    ),
    Flight(
      name: 'Хара-Улах - Тикси',
      company: _polar,
      departure: '13:20',
      arrival: '14:30',
      status: 'По расписанию',
    ),
    Flight(
      name: 'Москва - Тикси',
      company: _yakutia,
      departure: '09:40',
      arrival: '17:15',
      status: 'По расписанию',
    ),
    Flight(
      name: 'Тикси - Борогон',
      company: _polar,
      departure: '15:10',
      arrival: '16:00',
      status: 'Уточняется',
    ),
  ];

  static const _afterTomorrow = [
    Flight(
      name: 'Тикси - Якутск',
      company: _yakutia,
      departure: '07:30',
      arrival: '10:05',
      status: 'По расписанию',
    ),
    Flight(
      name: 'Таймылыр - Тикси',
      company: _polar,
      departure: '11:45',
      arrival: '13:35',
      status: 'По расписанию',
    ),
  ];

  /// Current flights of a day, without subscribing.
  List<Flight> flightsOn(DateTime date) =>
      List.unmodifiable(_days[dbDateKey(date)] ?? const <Flight>[]);

  @override
  Stream<List<Flight>> watchFlights(DateTime date) async* {
    yield flightsOn(date);
    yield* _changes.stream.map((_) => flightsOn(date));
  }

  Future<void> _mutate(
    DateTime date,
    void Function(List<Flight> day) change,
  ) async {
    await Future<void>.delayed(latency);
    final key = dbDateKey(date);
    final day = [...?_days[key]];
    change(day);
    _days[key] = day;
    _changes.add(null);
  }

  @override
  Future<void> addFlight(DateTime date, Flight flight) =>
      _mutate(date, (day) => day.add(flight));

  @override
  Future<void> updateFlight(DateTime date, int index, Flight flight) =>
      _mutate(date, (day) => day[index] = flight);

  @override
  Future<void> deleteFlight(DateTime date, int index) =>
      _mutate(date, (day) => day.removeAt(index));

  @override
  Stream<String?> watchUser() async* {
    yield _user;
    yield* _userChanges.stream;
  }

  @override
  String? get currentUser => _user;

  void _setUser(String? user) {
    _user = user;
    _userChanges.add(user);
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(latency);
    if (email.trim().isEmpty || password.isEmpty) {
      throw const RepositoryException(RepositoryError.wrongCredentials);
    }
    _setUser(email.trim());
  }

  @override
  Future<void> signOut() async => _setUser(null);

  @override
  Future<void> resetPassword(String email) => Future<void>.delayed(latency);

  @override
  Future<void> setRouteNotifications(FlightRoute route, bool enabled) =>
      Future<void>.delayed(latency);
}
