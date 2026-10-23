import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../components/badges.dart';
import '../components/cell.dart';
import '../components/flight_card.dart';
import '../components/snackbar.dart';
import '../data/avia_repository.dart';
import '../data/flight.dart';
import '../data/settings_store.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/formatters.dart';

Future<void> showFlightDetails(
  BuildContext context, {
  required Flight flight,
  required DateTime date,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => FlightDetailsSheet(flight: flight, date: date),
);

/// VKUI `ModalPage` with a flight and a switch for route notifications.
class FlightDetailsSheet extends StatefulWidget {
  const FlightDetailsSheet({
    super.key,
    required this.flight,
    required this.date,
  });

  final Flight flight;
  final DateTime date;

  @override
  State<FlightDetailsSheet> createState() => _FlightDetailsSheetState();
}

class _FlightDetailsSheetState extends State<FlightDetailsSheet> {
  bool _saving = false;

  Future<void> _toggleNotifications(bool enabled) async {
    final route = widget.flight.route;
    setState(() => _saving = true);
    try {
      await context.read<AviaRepository>().setRouteNotifications(
        route,
        enabled,
      );
      await SettingsStore.setRouteNotifications(route, enabled);
    } catch (e) {
      if (mounted) showErrorSnackbar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final flight = widget.flight;
    final route = flight.route;
    final duration = flight.duration;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatFullDate(widget.date),
                    style: VkTypography.subhead.copyWith(
                      color: vk.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route.title,
                    style: VkTypography.title1.copyWith(color: vk.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  StatusBadge(flight.status, large: true),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: vk.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: FlightTimeline(
                flight: flight,
                background: vk.backgroundSecondary,
              ),
            ),
            _InfoRow(label: 'Авиакомпания', value: flight.company),
            if (duration != null)
              _InfoRow(label: 'Время в пути', value: formatDuration(duration)),
            _InfoRow(
              label: 'Тип рейса',
              value: route.isOutbound ? 'Вылет из Тикси' : 'Прилёт в Тикси',
            ),
            if (route.topic.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  height: 0.5,
                  thickness: 0.5,
                  indent: 16,
                  endIndent: 16,
                  color: vk.separatorPrimaryAlpha,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: SettingsStore.notifications.listenable(
                  keys: [route.name],
                ),
                builder: (context, _, _) => VkSwitchCell(
                  before: VkIconAvatar(
                    color: vk.backgroundAccent,
                    child: const Icon(
                      Icons.notifications_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  title: 'Уведомлять об изменениях',
                  subtitle: 'Если диспетчер добавит или изменит рейс',
                  value: SettingsStore.routeNotifications(route),
                  loading: _saving,
                  onChanged: _toggleNotifications,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Row(
        children: [
          Text(
            label,
            style: VkTypography.text.copyWith(color: vk.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: VkTypography.text.copyWith(color: vk.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
