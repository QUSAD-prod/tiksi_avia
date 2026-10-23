import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/avia_repository.dart';
import 'data/settings_store.dart';
import 'pages/splash_page.dart';
import 'theme/app_theme.dart';

class TiksiAviaApp extends StatelessWidget {
  const TiksiAviaApp({
    super.key,
    required this.repository,
    this.home = const SplashPage(),
  });

  final AviaRepository repository;
  final Widget home;

  static final _light = buildAppTheme(Brightness.light);
  static final _dark = buildAppTheme(Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return Provider<AviaRepository>.value(
      value: repository,
      child: ValueListenableBuilder(
        valueListenable: SettingsStore.settings.listenable(),
        builder: (context, _, _) => MaterialApp(
          title: 'TiksiAvia',
          debugShowCheckedModeBanner: false,
          theme: _light,
          darkTheme: _dark,
          themeMode: SettingsStore.themeMode,
          locale: const Locale('ru'),
          supportedLocales: const [Locale('ru')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: home,
        ),
      ),
    );
  }
}
