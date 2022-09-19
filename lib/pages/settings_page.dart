import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:tiksi_avia/components/settings_button.dart';
import 'package:tiksi_avia/components/text.dart';
import 'package:tiksi_avia/pages/notification_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> with RouteAware {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
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
            children: [
              getSeporator(),
              getName('УВЕДОМЛЕНИЯ'),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          const NotificationSettingsPage(),
                    ),
                  ),
                  highlightColor:
                      Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFFEBEBEB)
                          : const Color(0xFF2B2B2B),
                  splashFactory: InkRipple.splashFactory,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            "Параметры уведомлений",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              getSeporator(),
              getName('ТЕМЫ'),
              SettingsButton(
                text: 'Системная',
                value: box.get('theme', defaultValue: 'system') == 'system',
                onClickSelect: () => {box.put('theme', 'system')},
                settingsButtonMode: SettingsButtonMode.selectBt,
              ),
              SettingsButton(
                text: 'Светлая',
                value: box.get('theme', defaultValue: 'system') == 'light',
                onClickSelect: () => {box.put('theme', 'light')},
                settingsButtonMode: SettingsButtonMode.selectBt,
              ),
              SettingsButton(
                text: 'Тёмная',
                value: box.get('theme', defaultValue: 'system') == 'dark',
                onClickSelect: () => {box.put('theme', 'dark')},
                settingsButtonMode: SettingsButtonMode.selectBt,
              ),
              getSeporator(),
              getName('О ПРИЛОЖЕНИИ'),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 24,
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Версия приложения:",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SecondaryText(
                        text: _packageInfo.version,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
