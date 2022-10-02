import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiksi_avia/pages/splash_screen.dart';

Future<void> _messageHandler(RemoteMessage message) async {}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('settings');
  await Hive.openBox<dynamic>('data');
  await Hive.openBox<dynamic>("notification settings");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final RouteObserver<PageRoute> _routeObserver = RouteObserver();

  ThemeMode getTheme(Box box) {
    switch (box.get('theme', defaultValue: 'system')) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return Provider.value(
      value: _routeObserver,
      child: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (BuildContext context, Box box, Widget? widget) => MaterialApp(
          navigatorObservers: [_routeObserver],
          themeMode: getTheme(box),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru'),
          ],
          theme: ThemeData(
            useMaterial3: true,
            splashFactory: InkRipple.splashFactory,
            primaryColor: const Color(0xFF2688EB),
            cardTheme: CardTheme(
              color: const Color(0xFFFFFFFF),
              shadowColor: const Color(0xFF000000).withOpacity(0.08),
            ),
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              actionsIconTheme: IconThemeData(color: Color(0xFF2688EB)),
              iconTheme: IconThemeData(color: Color(0xFF2688EB)),
              shadowColor: Colors.transparent,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              titleSpacing: 8,
              foregroundColor: Colors.black,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              unselectedItemColor: Color(0xFF99A2AD),
              selectedItemColor: Color(0xFF2975CC),
              backgroundColor: Color(0xFFF9F9F9),
              selectedLabelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            backgroundColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            splashFactory: InkRipple.splashFactory,
            primaryColor: Colors.white,
            primaryColorLight: const Color(0xFF71AAEB),
            cardTheme: CardTheme(
              color: const Color(0xFF19191A),
              shadowColor: const Color(0xFF000000).withOpacity(0.08),
            ),
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Color(0xFF19191A),
              actionsIconTheme: IconThemeData(color: Color(0xFF71AAEB)),
              iconTheme: IconThemeData(color: Color(0xFF71AAEB)),
              shadowColor: Colors.transparent,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
              titleSpacing: 8,
              foregroundColor: Colors.white,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              unselectedItemColor: Color(0xFF767876),
              selectedItemColor: Colors.white,
              backgroundColor: Color(0xFF2C2D2C),
              selectedLabelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            backgroundColor: const Color(0xFF19191A),
            scaffoldBackgroundColor: const Color(0xFF19191A),
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
