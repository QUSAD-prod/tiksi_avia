import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/cell.dart';
import '../components/group.dart';
import '../components/panel_header.dart';
import '../components/segmented_control.dart';
import '../components/vk_icon.dart';
import '../config.dart';
import '../data/settings_store.dart';
import '../theme/vk_colors.dart';
import '../utils/navigation.dart';
import 'notification_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Scaffold(
      backgroundColor: vk.background,
      appBar: const VkPanelHeader(title: 'Настройки'),
      body: ListView(
        padding: EdgeInsets.only(
          top: 4,
          bottom: MediaQuery.paddingOf(context).bottom + 12,
        ),
        children: [
          ValueListenableBuilder(
            valueListenable: SettingsStore.settings.listenable(),
            builder: (context, _, _) => VkGroup(
              header: 'Оформление',
              padding: const EdgeInsets.all(12),
              footer:
                  'Системная тема переключается вместе с настройками телефона',
              children: [
                VkSegmentedControl<ThemeMode>(
                  options: const {
                    ThemeMode.system: 'Системная',
                    ThemeMode.light: 'Светлая',
                    ThemeMode.dark: 'Тёмная',
                  },
                  value: SettingsStore.themeMode,
                  onChanged: (mode) => SettingsStore.themeMode = mode,
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: SettingsStore.notifications.listenable(),
            builder: (context, _, _) {
              final count = SettingsStore.enabledRoutesCount;
              return VkGroup(
                header: 'Уведомления',
                children: [
                  VkSimpleCell(
                    before: Icon(
                      Icons.notifications_none_rounded,
                      size: 28,
                      color: vk.iconAccent,
                    ),
                    title: 'Push-уведомления',
                    indicator: count == 0 ? 'Выкл.' : '$count',
                    chevron: true,
                    onTap: () => pushPage<void>(
                      context,
                      const NotificationSettingsPage(),
                    ),
                  ),
                ],
              );
            },
          ),
          VkGroup(
            header: 'О приложении',
            children: [
              FutureBuilder<PackageInfo>(
                future: _packageInfo,
                builder: (context, snapshot) {
                  final info = snapshot.data;
                  return VkSimpleCell(
                    before: Icon(
                      Icons.info_outline_rounded,
                      size: 28,
                      color: vk.iconAccent,
                    ),
                    title: 'Версия',
                    indicator: info == null
                        ? ''
                        : '${info.version} (${info.buildNumber})',
                  );
                },
              ),
              VkSimpleCell(
                before: VkIcon('all_categories_icon', color: vk.iconAccent),
                title: 'Другие приложения автора',
                chevron: true,
                onTap: () => launchUrl(
                  Uri.parse(AppConfig.developerAppsUrl),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
          const VkFooter('TiksiAvia · by Oslopov', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
