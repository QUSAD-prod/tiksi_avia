import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'flight_route.dart';

/// Local settings in Hive. Box and key names are shared with older app
/// versions, so existing users keep their theme and notification choices.
abstract final class SettingsStore {
  static const _settingsBox = 'settings';
  static const _notificationsBox = 'notification settings';
  static const _themeKey = 'theme';

  static Box<dynamic> get settings => Hive.box(_settingsBox);

  /// Route name → whether push notifications for it are on.
  static Box<dynamic> get notifications => Hive.box(_notificationsBox);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(_settingsBox);
    await Hive.openBox<dynamic>(_notificationsBox);
    // Flights used to be cached here; the database does that itself now.
    await Hive.deleteBoxFromDisk('data');
  }

  static ThemeMode get themeMode =>
      switch (settings.get(_themeKey, defaultValue: 'system')) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static set themeMode(ThemeMode mode) => settings.put(_themeKey, mode.name);

  static bool routeNotifications(FlightRoute route) =>
      notifications.get(route.name, defaultValue: false) == true;

  static Future<void> setRouteNotifications(FlightRoute route, bool enabled) =>
      notifications.put(route.name, enabled);

  static int get enabledRoutesCount =>
      FlightRoute.all.where(routeNotifications).length;
}
