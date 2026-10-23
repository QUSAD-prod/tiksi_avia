import 'package:flutter/foundation.dart';

import '../utils/formatters.dart';
import 'flight_route.dart';

/// One row of the board, stored in the Realtime Database under the day key.
@immutable
class Flight {
  const Flight({
    required this.name,
    required this.company,
    required this.departure,
    required this.arrival,
    required this.status,
  });

  factory Flight.fromMap(Map<dynamic, dynamic> map) => Flight(
    name: '${map['name'] ?? ''}',
    company: '${map['company'] ?? ''}',
    departure: '${map['departure'] ?? ''}',
    arrival: '${map['arrival'] ?? ''}',
    status: '${map['status'] ?? ''}',
  );

  /// Route name as stored in the database, e.g. `Тикси - Якутск`.
  final String name;
  final String company;

  /// Local time, `HH:mm`.
  final String departure;
  final String arrival;

  /// Free text entered by the dispatcher.
  final String status;

  FlightRoute get route => FlightRoute.byName(name);

  StatusTone get statusTone => StatusTone.of(status);

  /// Time in the air; flights that land after midnight are handled.
  Duration? get duration {
    final from = parseTime(departure);
    final to = parseTime(arrival);
    if (from == null || to == null) return null;
    var minutes = (to.hour * 60 + to.minute) - (from.hour * 60 + from.minute);
    if (minutes < 0) minutes += 24 * 60;
    return Duration(minutes: minutes);
  }

  /// Minutes since midnight, for sorting the board.
  int get departureMinutes {
    final time = parseTime(departure);
    return time == null ? 24 * 60 : time.hour * 60 + time.minute;
  }

  Map<String, String> toMap() => {
    'name': name,
    'company': company,
    'departure': departure,
    'arrival': arrival,
    'status': status,
  };

  Flight copyWith({
    String? name,
    String? company,
    String? departure,
    String? arrival,
    String? status,
  }) => Flight(
    name: name ?? this.name,
    company: company ?? this.company,
    departure: departure ?? this.departure,
    arrival: arrival ?? this.arrival,
    status: status ?? this.status,
  );

  @override
  bool operator ==(Object other) =>
      other is Flight &&
      other.name == name &&
      other.company == company &&
      other.departure == departure &&
      other.arrival == arrival &&
      other.status == status;

  @override
  int get hashCode => Object.hash(name, company, departure, arrival, status);
}

/// Color of the status badge, guessed from the dispatcher's free-text status.
enum StatusTone {
  positive,
  accent,
  warning,
  negative,
  neutral;

  static StatusTone of(String status) {
    final s = status.toLowerCase();
    if (s.contains('отмен')) return negative;
    if (s.contains('задерж') || s.contains('перен') || s.contains('ожида')) {
      return warning;
    }
    if (s.contains('прибы') ||
        s.contains('приземл') ||
        s.contains('по расписан')) {
      return positive;
    }
    if (s.contains('вылет') ||
        s.contains('в пути') ||
        s.contains('в полёт') ||
        s.contains('в полет') ||
        s.contains('посадк') ||
        s.contains('регистр')) {
      return accent;
    }
    return neutral;
  }
}
