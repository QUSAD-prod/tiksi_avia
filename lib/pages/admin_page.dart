import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cell.dart';
import '../components/group.dart';
import '../components/panel_header.dart';
import '../components/snackbar.dart';
import '../data/avia_repository.dart';
import '../data/flight.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/formatters.dart';
import '../utils/navigation.dart';
import 'flight_form_page.dart';
import 'flights_editor_page.dart';

/// Dispatcher home: schedule stats and entry points to edit it.
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late final AviaRepository _repository = context.read<AviaRepository>();
  late final DateTime _today = dateOnly(DateTime.now());
  late final Stream<List<Flight>> _todayFlights = _repository.watchFlights(
    _today,
  );
  late final Stream<List<Flight>> _tomorrowFlights = _repository.watchFlights(
    _today.add(const Duration(days: 1)),
  );

  Future<void> _signOut() async {
    try {
      await _repository.signOut();
      if (!mounted) return;
      showVkSnackbar(context, 'Вы вышли из аккаунта');
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showErrorSnackbar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final email = _repository.currentUser ?? '';
    return Scaffold(
      backgroundColor: vk.background,
      appBar: const VkPanelHeader(title: 'Панель диспетчера'),
      body: ListView(
        padding: EdgeInsets.only(
          top: 12,
          bottom: MediaQuery.paddingOf(context).bottom + 12,
        ),
        children: [
          VkGroup(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: vk.backgroundAccent,
                    child: Text(
                      email.isEmpty ? '?' : email[0].toUpperCase(),
                      style: VkTypography.title2.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: VkTypography.title3.copyWith(
                            color: vk.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Диспетчер · аэропорт Тикси',
                          style: VkTypography.subhead.copyWith(
                            color: vk.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(label: 'Сегодня', flights: _todayFlights),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(label: 'Завтра', flights: _tomorrowFlights),
                ),
              ],
            ),
          ),
          VkGroup(
            header: 'Расписание',
            children: [
              VkSimpleCell(
                before: VkIconAvatar(
                  size: 36,
                  color: vk.backgroundAccent,
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: 'Добавить рейс',
                subtitle: 'Появится на табло сразу после сохранения',
                chevron: true,
                onTap: () => pushPage<void>(context, const FlightFormPage()),
              ),
              VkSimpleCell(
                before: VkIconAvatar(
                  size: 36,
                  color: vk.textPositive,
                  child: const Icon(
                    Icons.edit_calendar_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: 'Редактировать рейсы',
                subtitle: 'Время, статус или удаление',
                chevron: true,
                onTap: () => pushPage<void>(context, const FlightsEditorPage()),
              ),
            ],
          ),
          VkGroup(
            children: [
              VkSimpleCell(
                before: Icon(
                  Icons.logout_rounded,
                  size: 24,
                  color: vk.textNegative,
                ),
                title: 'Выйти из аккаунта',
                destructive: true,
                onTap: _signOut,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.flights});

  final String label;
  final Stream<List<Flight>> flights;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return VkCard(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<List<Flight>>(
        stream: flights,
        builder: (context, snapshot) {
          final count = snapshot.data?.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: VkTypography.subhead.copyWith(color: vk.textSecondary),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: count == null ? '—' : '$count',
                      style: VkTypography.title1.copyWith(
                        color: vk.textPrimary,
                      ),
                    ),
                    if (count != null)
                      TextSpan(
                        text: ' ${pluralize(count, 'рейс', 'рейса', 'рейсов')}',
                        style: VkTypography.subhead.copyWith(
                          color: vk.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
