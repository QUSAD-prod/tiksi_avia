import 'dart:io' show Directory, File, Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/demo_avia_repository.dart';
import '../data/flight.dart';
import '../data/flight_route.dart';
import '../data/settings_store.dart';
import '../pages/admin_page.dart';
import '../pages/auth_page.dart';
import '../pages/board_page.dart';
import '../pages/flight_form_page.dart';
import '../pages/flights_editor_page.dart';
import '../pages/notification_settings_page.dart';
import '../pages/settings_page.dart';
import '../pages/splash_page.dart';
import '../utils/formatters.dart';

/// Screens the demo build can open directly, for portfolio screenshots
/// (see `tool/screenshots.sh`).
enum DemoScene {
  splash,
  board,
  tomorrow,
  drawer,
  details,
  auth,
  admin,
  editor,
  add,
  edit,
  settings,
  notifications;

  /// Read from the `TIKSI_SCENE` environment variable or, because Dart sees
  /// no environment variables on iOS, from a `tiksi_scene` file in the app's
  /// temporary directory (written there by the screenshot script).
  static DemoScene? fromLaunch() {
    if (kIsWeb) return null;
    var name = Platform.environment['TIKSI_SCENE'];
    final file = File('${Directory.systemTemp.path}/tiksi_scene');
    if (name == null && file.existsSync()) {
      name = file.readAsStringSync().trim();
    }
    return values.asNameMap()[name];
  }

  bool get needsDispatcher => const {admin, editor, add, edit}.contains(this);
}

DemoAviaRepository createDemoRepository(DemoScene? scene) => DemoAviaRepository(
  signedInAs: scene?.needsDispatcher == true ? 'dispatcher@tiksi.aero' : null,
);

/// A few subscribed routes, so the demo does not start with every switch off.
Future<void> seedDemoSettings() async {
  if (SettingsStore.notifications.isNotEmpty) return;
  for (final name in ['Тикси - Якутск', 'Якутск - Тикси', 'Москва - Тикси']) {
    await SettingsStore.setRouteNotifications(FlightRoute.byName(name), true);
  }
}

Widget buildDemoScene(DemoScene scene, DemoAviaRepository repository) {
  final today = dateOnly(DateTime.now());
  final board = GlobalKey<BoardPageState>();
  final todayFlights = repository.flightsOn(today);
  int indexOf(String name) => todayFlights.indexWhere((f) => f.name == name);

  return switch (scene) {
    DemoScene.splash => const SplashPage(duration: Duration(days: 1)),
    DemoScene.board => const BoardPage(),
    DemoScene.tomorrow => const BoardPage(initialTab: 1),
    DemoScene.drawer => _AfterStart(
      action: () => board.currentState?.openDrawer(),
      child: BoardPage(key: board),
    ),
    DemoScene.details => _AfterStart(
      action: () => board.currentState?.showDetails(
        todayFlights[indexOf('Якутск - Тикси')],
      ),
      child: BoardPage(key: board),
    ),
    DemoScene.auth => const AuthPage(),
    DemoScene.admin => const AdminPage(),
    DemoScene.editor => const FlightsEditorPage(),
    DemoScene.add => FlightFormPage(
      date: today.add(const Duration(days: 2)),
      flight: const Flight(
        name: 'Тикси - Москва',
        company: 'Якутия',
        departure: '16:50',
        arrival: '19:35',
        status: 'По расписанию',
      ),
    ),
    DemoScene.edit => FlightFormPage(
      date: today,
      flight: todayFlights[indexOf('Тикси - Борогон-Хара-Улах')],
      index: indexOf('Тикси - Борогон-Хара-Улах'),
    ),
    DemoScene.settings => const SettingsPage(),
    DemoScene.notifications => const NotificationSettingsPage(),
  };
}

/// Runs [action] once the first screen has settled (data loaded, splash gone).
class _AfterStart extends StatefulWidget {
  const _AfterStart({required this.action, required this.child});

  final VoidCallback action;
  final Widget child;

  @override
  State<_AfterStart> createState() => _AfterStartState();
}

class _AfterStartState extends State<_AfterStart> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) widget.action();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
