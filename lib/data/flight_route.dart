import 'package:flutter/foundation.dart';

/// A route served from Tiksi. [name] is the value stored in the database and the
/// key of the notification setting; [topic] is the FCM topic of the route.
@immutable
class FlightRoute {
  const FlightRoute(this.name, this.topic, {this.stops});

  final String name;
  final String topic;

  /// Intermediate + final destinations of multi-stop routes, for display.
  final List<String>? stops;

  static const home = 'Тикси';

  static const all = [
    FlightRoute('Тикси - Борогон', '0'),
    FlightRoute('Борогон - Тикси', '1'),
    FlightRoute('Тикси - Хара-Улах', '2'),
    FlightRoute('Хара-Улах - Тикси', '3'),
    FlightRoute('Тикси - Булун', '4'),
    FlightRoute('Булун - Тикси', '5'),
    FlightRoute('Тикси - Таймылыр', '6'),
    FlightRoute('Таймылыр - Тикси', '7'),
    FlightRoute('Тикси - Сиктях', '8'),
    FlightRoute('Сиктях - Тикси', '9'),
    FlightRoute('Тикси - Якутск', '10'),
    FlightRoute('Якутск - Тикси', '11'),
    FlightRoute('Тикси - Кюсюр', '12'),
    FlightRoute('Кюсюр - Тикси', '13'),
    FlightRoute('Тикси - Москва', '14'),
    FlightRoute('Москва - Тикси', '15'),
    FlightRoute('Тикси - Булун-Сиктях', '16', stops: ['Булун', 'Сиктях']),
    FlightRoute(
      'Тикси - Борогон-Хара-Улах',
      '17',
      stops: ['Борогон', 'Хара-Улах'],
    ),
  ];

  static List<FlightRoute> get outbound =>
      all.where((r) => r.isOutbound).toList();

  static List<FlightRoute> get inbound =>
      all.where((r) => !r.isOutbound).toList();

  /// Unknown names (typed by hand in old app versions) get a route without a topic.
  static FlightRoute byName(String name) => all.firstWhere(
    (r) => r.name == name,
    orElse: () => FlightRoute(name, ''),
  );

  String get from => name.split(' - ').first.trim();

  String get to => stops?.join(' · ') ?? name.split(' - ').last.trim();

  bool get isOutbound => from == home;

  /// `Тикси → Якутск`
  String get title => '$from → $to';
}
