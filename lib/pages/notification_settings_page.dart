import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../components/cell.dart';
import '../components/group.dart';
import '../components/panel_header.dart';
import '../components/snackbar.dart';
import '../data/avia_repository.dart';
import '../data/flight_route.dart';
import '../data/settings_store.dart';
import '../theme/vk_colors.dart';

/// Per-route push subscriptions (one FCM topic per route).
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final _pending = <String>{};

  Future<void> _toggle(FlightRoute route, bool enabled) async {
    setState(() => _pending.add(route.name));
    try {
      await context.read<AviaRepository>().setRouteNotifications(
        route,
        enabled,
      );
      await SettingsStore.setRouteNotifications(route, enabled);
    } catch (e) {
      if (mounted) showErrorSnackbar(context, e);
    } finally {
      if (mounted) setState(() => _pending.remove(route.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    Widget cell(FlightRoute route) => VkSwitchCell(
      title: route.title,
      value: SettingsStore.routeNotifications(route),
      loading: _pending.contains(route.name),
      onChanged: (value) => _toggle(route, value),
    );

    return Scaffold(
      backgroundColor: vk.background,
      appBar: const VkPanelHeader(title: 'Уведомления'),
      body: ValueListenableBuilder(
        valueListenable: SettingsStore.notifications.listenable(),
        builder: (context, _, _) => ListView(
          padding: EdgeInsets.only(
            top: 4,
            bottom: MediaQuery.paddingOf(context).bottom + 12,
          ),
          children: [
            const VkFooter(
              'Пришлём push, когда диспетчер добавит или изменит рейс '
              'по выбранному направлению',
            ),
            VkGroup(
              header: 'Вылет из Тикси',
              children: FlightRoute.outbound.map(cell).toList(),
            ),
            VkGroup(
              header: 'Прилёт в Тикси',
              children: FlightRoute.inbound.map(cell).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
