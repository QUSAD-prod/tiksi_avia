import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiksi_avia/data/flight.dart';
import 'package:tiksi_avia/data/flight_route.dart';
import 'package:tiksi_avia/utils/formatters.dart';

void main() {
  group('formatters', () {
    test('database key keeps the legacy unpadded format', () {
      expect(dbDateKey(DateTime(2026, 3, 7)), '7-3-2026');
    });

    test('parses times written by old and new versions', () {
      expect(parseTime('7:05'), const TimeOfDay(hour: 7, minute: 5));
      expect(parseTime('07:05'), const TimeOfDay(hour: 7, minute: 5));
      expect(parseTime('25:00'), isNull);
      expect(parseTime('abc'), isNull);
      expect(displayTime('7:05'), '07:05');
    });

    test('formats dates and durations in Russian', () {
      expect(formatFullDate(DateTime(2026, 10, 22)), 'Четверг, 22 октября');
      expect(formatDuration(const Duration(minutes: 155)), '2 ч 35 мин');
      expect(formatDuration(const Duration(minutes: 45)), '45 мин');
      expect(formatDuration(const Duration(hours: 3)), '3 ч');
    });

    test('pluralizes flights', () {
      expect(formatFlightsCount(1), '1 рейс');
      expect(formatFlightsCount(3), '3 рейса');
      expect(formatFlightsCount(5), '5 рейсов');
      expect(formatFlightsCount(11), '11 рейсов');
      expect(formatFlightsCount(22), '22 рейса');
    });
  });

  group('Flight', () {
    const flight = Flight(
      name: 'Тикси - Якутск',
      company: 'Якутия',
      departure: '07:30',
      arrival: '10:05',
      status: 'По расписанию',
    );

    test('round-trips through the database map', () {
      expect(Flight.fromMap(flight.toMap()), flight);
    });

    test('computes duration, including flights past midnight', () {
      expect(flight.duration, const Duration(hours: 2, minutes: 35));
      expect(
        flight.copyWith(departure: '23:30', arrival: '0:40').duration,
        const Duration(hours: 1, minutes: 10),
      );
    });

    test('maps free-text statuses to tones', () {
      expect(StatusTone.of('Отменён: метеоусловия'), StatusTone.negative);
      expect(StatusTone.of('Задерживается до 13:30'), StatusTone.warning);
      expect(StatusTone.of('Идёт посадка'), StatusTone.accent);
      expect(StatusTone.of('Прибыл'), StatusTone.positive);
      expect(StatusTone.of('Что-то ещё'), StatusTone.neutral);
    });
  });

  group('FlightRoute', () {
    test('keeps the FCM topics of all 18 routes', () {
      expect(FlightRoute.all, hasLength(18));
      expect(FlightRoute.all.map((r) => r.topic).toSet(), hasLength(18));
      expect(FlightRoute.byName('Тикси - Якутск').topic, '10');
    });

    test('splits routes into outbound and inbound', () {
      expect(FlightRoute.outbound.every((r) => r.from == 'Тикси'), isTrue);
      expect(FlightRoute.inbound.every((r) => r.to == 'Тикси'), isTrue);
      expect(
        FlightRoute.byName('Тикси - Борогон-Хара-Улах').title,
        'Тикси → Борогон · Хара-Улах',
      );
    });
  });
}
