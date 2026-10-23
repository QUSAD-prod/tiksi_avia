import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tiksi_avia/data/avia_repository.dart';
import 'package:tiksi_avia/data/demo_avia_repository.dart';
import 'package:tiksi_avia/pages/board_page.dart';
import 'package:tiksi_avia/theme/app_theme.dart';

Widget _app(AviaRepository repository) => Provider<AviaRepository>.value(
  value: repository,
  child: MaterialApp(
    theme: buildAppTheme(Brightness.light),
    locale: const Locale('ru'),
    supportedLocales: const [Locale('ru')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: const BoardPage(),
  ),
);

void main() {
  testWidgets('shows today flights sorted by departure', (tester) async {
    final repository = DemoAviaRepository(latency: Duration.zero);
    await tester.pumpWidget(_app(repository));
    await tester.pump();
    await tester.pump();

    expect(find.text('Табло'), findsOneWidget);
    expect(find.text('Сегодня'), findsOneWidget);
    expect(find.text('Тикси → Якутск'), findsOneWidget);
    expect(find.text('07:30'), findsOneWidget);
    expect(find.textContaining('8 рейсов'), findsOneWidget);
  });

  testWidgets('shows a placeholder for a day without flights', (tester) async {
    final repository = DemoAviaRepository(
      today: DateTime.now().subtract(const Duration(days: 30)),
      latency: Duration.zero,
    );
    await tester.pumpWidget(_app(repository));
    await tester.pump();
    await tester.pump();

    expect(find.text('Рейсов пока нет'), findsOneWidget);
  });
}
