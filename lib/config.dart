/// Compile-time switches passed with `--dart-define`.
abstract final class AppConfig {
  /// `--dart-define=DEMO=true` runs the app on built-in sample data, without
  /// Firebase. Used for portfolio screenshots and for trying the app locally.
  static const bool demo = bool.fromEnvironment('DEMO');

  static const String developerAppsUrl =
      'https://play.google.com/store/apps/developer?id=Artem+Oslopov';
}
