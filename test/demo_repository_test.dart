import 'package:flutter_test/flutter_test.dart';
import 'package:tiksi_avia/data/avia_repository.dart';
import 'package:tiksi_avia/data/demo_avia_repository.dart';
import 'package:tiksi_avia/data/flight.dart';

void main() {
  final today = DateTime(2026, 10, 22);
  late DemoAviaRepository repository;

  setUp(() {
    repository = DemoAviaRepository(today: today, latency: Duration.zero);
  });

  const flight = Flight(
    name: 'Тикси - Кюсюр',
    company: 'Полярные авиалинии',
    departure: '09:00',
    arrival: '10:20',
    status: 'По расписанию',
  );

  test('streams the sample schedule and every change to it', () async {
    final updates = repository.watchFlights(today);
    final initial = repository.flightsOn(today).length;
    expect(initial, greaterThan(0));

    expectLater(
      updates.map((flights) => flights.length),
      emitsInOrder([initial, initial + 1, initial + 1, initial]),
    );

    await repository.addFlight(today, flight);
    await repository.updateFlight(
      today,
      initial,
      flight.copyWith(status: 'Вылетел'),
    );
    expect(repository.flightsOn(today).last.status, 'Вылетел');
    await repository.deleteFlight(today, initial);
  });

  test('days without flights are empty', () async {
    expect(await repository.watchFlights(DateTime(2030)).first, isEmpty);
  });

  test('signs in with any credentials and reports the user', () async {
    expect(repository.currentUser, isNull);
    expectLater(repository.watchUser(), emitsInOrder([null, 'a@b.ru', null]));
    await repository.signIn(' a@b.ru ', 'secret');
    expect(repository.currentUser, 'a@b.ru');
    await repository.signOut();
  });

  test('rejects empty credentials', () {
    expect(
      repository.signIn('', ''),
      throwsA(
        isA<RepositoryException>().having(
          (e) => e.error,
          'error',
          RepositoryError.wrongCredentials,
        ),
      ),
    );
  });
}
