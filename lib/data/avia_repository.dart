import 'flight.dart';
import 'flight_route.dart';

/// Everything the UI needs from the backend. Implemented by
/// [FirebaseAviaRepository] in production and [DemoAviaRepository] for demos.
abstract interface class AviaRepository {
  /// Flights of a day in database order; the list index identifies a flight
  /// for [updateFlight] and [deleteFlight].
  Stream<List<Flight>> watchFlights(DateTime date);

  Future<void> addFlight(DateTime date, Flight flight);

  Future<void> updateFlight(DateTime date, int index, Flight flight);

  Future<void> deleteFlight(DateTime date, int index);

  /// Email of the signed-in dispatcher, `null` for passengers.
  Stream<String?> watchUser();

  String? get currentUser;

  Future<void> signIn(String email, String password);

  Future<void> signOut();

  Future<void> resetPassword(String email);

  Future<void> setRouteNotifications(FlightRoute route, bool enabled);
}

enum RepositoryError {
  network('Нет подключения к интернету'),
  wrongCredentials('Неверный email или пароль'),
  userNotFound('Пользователь с таким email не найден'),
  tooManyRequests('Слишком много попыток, попробуйте позже'),
  unknown('Что-то пошло не так, попробуйте ещё раз');

  const RepositoryError(this.message);

  final String message;
}

class RepositoryException implements Exception {
  const RepositoryException(this.error);

  final RepositoryError error;

  String get message => error.message;

  @override
  String toString() => 'RepositoryException(${error.name})';
}
