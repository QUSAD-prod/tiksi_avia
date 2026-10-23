import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'config.dart';
import 'data/avia_repository.dart';
import 'data/firebase_avia_repository.dart';
import 'data/settings_store.dart';
import 'demo/demo_scenes.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsStore.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final AviaRepository repository;
  Widget home = const SplashPage();
  final scene = AppConfig.demo ? DemoScene.fromLaunch() : null;

  if (AppConfig.demo) {
    final demo = createDemoRepository(scene);
    await seedDemoSettings();
    if (scene != null) home = buildDemoScene(scene, demo);
    repository = demo;
  } else {
    await Firebase.initializeApp();
    if (!kIsWeb) FirebaseDatabase.instance.setPersistenceEnabled(true);
    repository = FirebaseAviaRepository();
  }

  runApp(TiksiAviaApp(repository: repository, home: home));

  if (scene != null) {
    // Clean screenshots: no clock, battery and signal around the Dynamic Island.
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }
}
