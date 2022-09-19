import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tiksi_avia/pages/avia_board_page.dart';

import '../components/settings_button.dart';
import '../components/text.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Параметры уведомлений'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(
                'assets/back_arrow.svg',
                color: Theme.of(context).appBarTheme.iconTheme!.color,
                height: 28,
                width: 28,
              ),
              iconSize: 28,
              splashRadius: 20,
            );
          },
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, Box box, widget) => ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              getSeporator(),
              getName('РЕЙСЫ'),
              SettingsButton(
                text: "Тикси - Борогон",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Борогон - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Хара-Улах",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Хара-Улах - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Булун",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Булун - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Таймылыр",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Таймылыр - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Сиктях",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Сиктях - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Якутск",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Якутск - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Кюсюр",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Кюсюр - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Москва",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Москва - Тикси",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Булун-Сиктях",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
              SettingsButton(
                text: "Тикси - Борогон-Хара-Улах",
                value: false,
                onClickSelect: () => {},
                settingsButtonMode: SettingsButtonMode.switchBt,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getName(String name) {
    return Container(
      height: 32,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Center(
        child: Row(
          children: [
            SecondaryText(
              text: name,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget getSeporator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 16,
      child: Center(
        child: Container(
          height: 0.5,
          color: (Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF363738)
                  : const Color(0xFFD7D8D9))
              .withOpacity(0.12),
        ),
      ),
    );
  }
}
