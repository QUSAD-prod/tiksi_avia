import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tiksi_avia/components/spinner.dart';
import 'package:tiksi_avia/pages/avia_board_page.dart';
import 'package:tiksi_avia/pages/fb.dart';

import '../components/settings_button.dart';
import '../components/text.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  Fb fb = Fb();

  @override
  void initState() {
    Hive.box("notification settings").put("loading", false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
          valueListenable: Hive.box("notification settings").listenable(),
          builder: (context, Box box, widget) => Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  getSeporator(),
                  getName('РЕЙСЫ'),
                  getSwitch("Тикси - Борогон", box),
                  getSwitch("Борогон - Тикси", box),
                  getSwitch("Тикси - Хара-Улах", box),
                  getSwitch("Хара-Улах - Тикси", box),
                  getSwitch("Тикси - Булун", box),
                  getSwitch("Булун - Тикси", box),
                  getSwitch("Тикси - Таймылыр", box),
                  getSwitch("Таймылыр - Тикси", box),
                  getSwitch("Тикси - Сиктях", box),
                  getSwitch("Сиктях - Тикси", box),
                  getSwitch("Тикси - Якутск", box),
                  getSwitch("Якутск - Тикси", box),
                  getSwitch("Тикси - Кюсюр", box),
                  getSwitch("Кюсюр - Тикси", box),
                  getSwitch("Тикси - Москва", box),
                  getSwitch("Москва - Тикси", box),
                  getSwitch("Тикси - Булун-Сиктях", box),
                  getSwitch("Тикси - Борогон-Хара-Улах", box),
                ],
              ),
              box.get('loading', defaultValue: false)
                  ? Container(
                      width: width,
                      height: height,
                      color: Colors.black.withOpacity(0.7),
                      child: const Center(
                        child: Spinner(),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSwitch(String name, Box box) {
    return SettingsButton(
      text: name,
      value: box.get(name, defaultValue: false),
      onClickSwitch: (value) async {
        bool result = true;
        box.put("loading", true);
        if (value) {
          await FirebaseMessaging.instance
              .subscribeToTopic(
                fb.getTopic(name),
              )
              .timeout(
                const Duration(seconds: 5),
                onTimeout: () => result = false,
              );
        } else {
          await FirebaseMessaging.instance
              .unsubscribeFromTopic(
                fb.getTopic(name),
              )
              .timeout(
                const Duration(seconds: 5),
                onTimeout: () => result = false,
              );
        }
        box.put("loading", false);
        box.put(name, result ? value : !value);
      },
      settingsButtonMode: SettingsButtonMode.switchBt,
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
