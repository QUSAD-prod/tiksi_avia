import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/cell.dart';
import '../components/vk_icon.dart';
import '../config.dart';
import '../data/avia_repository.dart';
import '../data/settings_store.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/navigation.dart';
import 'admin_page.dart';
import 'auth_page.dart';
import 'notification_settings_page.dart';
import 'settings_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late final AviaRepository _repository = context.read<AviaRepository>();
  late final Stream<String?> _user = _repository.watchUser();

  void _open(Widget page) {
    Scaffold.of(context).closeDrawer();
    pushPage<void>(context, page);
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      width: math.min(320, MediaQuery.sizeOf(context).width * 0.85),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/tiksiAvia.png',
                      width: 56,
                      height: 56,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TiksiAvia',
                          style: VkTypography.title2.copyWith(
                            color: vk.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppConfig.demo ? 'by Oslopov · демо' : 'by Oslopov',
                          style: VkTypography.subhead.copyWith(
                            color: vk.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<String?>(
              stream: _user,
              initialData: _repository.currentUser,
              builder: (context, snapshot) {
                final user = snapshot.data;
                return VkSimpleCell(
                  before: VkIcon('user_icon', color: vk.iconAccent),
                  title: user == null
                      ? 'Вход для диспетчера'
                      : 'Панель диспетчера',
                  subtitle: user,
                  onTap: () => _open(
                    user == null ? const AuthPage() : const AdminPage(),
                  ),
                );
              },
            ),
            VkSimpleCell(
              before: Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: vk.iconAccent,
              ),
              title: 'Уведомления',
              onTap: () => _open(const NotificationSettingsPage()),
            ),
            VkSimpleCell(
              before: VkIcon('settings_icon', color: vk.iconAccent),
              title: 'Настройки',
              onTap: () => _open(const SettingsPage()),
            ),
            const Spacer(),
            Divider(
              height: 0.5,
              thickness: 0.5,
              indent: 12,
              endIndent: 12,
              color: vk.separatorPrimaryAlpha,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: VkSimpleCell(
                    before: VkIcon('all_categories_icon', color: vk.iconAccent),
                    title: 'Другие приложения',
                    onTap: () => launchUrl(
                      Uri.parse(AppConfig.developerAppsUrl),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: dark ? 'Светлая тема' : 'Тёмная тема',
                  onPressed: () => SettingsStore.themeMode = dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                  icon: VkIcon(
                    dark ? 'sun_icon' : 'moon_icon',
                    color: vk.iconAccent,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
