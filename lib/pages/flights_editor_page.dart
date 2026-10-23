import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/button.dart';
import '../components/flight_card.dart';
import '../components/panel_header.dart';
import '../components/placeholder.dart';
import '../components/snackbar.dart';
import '../components/spinner.dart';
import '../components/vk_icon.dart';
import '../data/avia_repository.dart';
import '../data/flight.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/formatters.dart';
import '../utils/navigation.dart';
import 'flight_form_page.dart';

/// Dispatcher's list of flights for a chosen day, with edit and delete.
class FlightsEditorPage extends StatefulWidget {
  const FlightsEditorPage({super.key});

  /// Earliest day stored in the database.
  static final firstDate = DateTime(2021, 11, 30);

  @override
  State<FlightsEditorPage> createState() => _FlightsEditorPageState();
}

class _FlightsEditorPageState extends State<FlightsEditorPage> {
  late final AviaRepository _repository = context.read<AviaRepository>();
  final DateTime _today = dateOnly(DateTime.now());

  late final List<DateTime> _strip = [
    for (var i = -1; i <= 7; i++) _today.add(Duration(days: i)),
  ];

  late DateTime _date = _today;
  late Stream<List<Flight>> _flights = _repository.watchFlights(_date);

  void _select(DateTime date) {
    if (date == _date) return;
    setState(() {
      _date = date;
      _flights = _repository.watchFlights(date);
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: FlightsEditorPage.firstDate,
      lastDate: _strip.last,
      helpText: 'Дата рейсов',
    );
    if (date != null) _select(dateOnly(date));
  }

  Future<void> _delete(int index, Flight flight) async {
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Удалить рейс?'),
        content: Text(
          '«${flight.route.title}» в ${displayTime(flight.departure)} '
          'исчезнет с табло у всех пассажиров.',
        ),
        actions: [
          _dialogAction(
            context: context,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          _dialogAction(
            context: context,
            onPressed: () => Navigator.pop(context, true),
            destructive: true,
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _repository.deleteFlight(_date, index);
      if (mounted) showVkSnackbar(context, 'Рейс удалён');
    } catch (e) {
      if (mounted) showErrorSnackbar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Scaffold(
      backgroundColor: vk.background,
      appBar: VkPanelHeader(
        title: 'Рейсы',
        actions: [
          VkHeaderButton(
            tooltip: 'Выбрать дату',
            onPressed: _pickDate,
            child: VkIcon('calendar_icon', color: vk.iconAccent),
          ),
          VkHeaderButton(
            tooltip: 'Добавить рейс',
            onPressed: () =>
                pushPage<void>(context, FlightFormPage(date: _date)),
            child: Icon(Icons.add_rounded, size: 30, color: vk.iconAccent),
          ),
        ],
      ),
      body: Column(
        children: [
          _DateStrip(
            days: _strip,
            today: _today,
            selected: _date,
            onSelected: _select,
          ),
          Expanded(
            child: StreamBuilder<List<Flight>>(
              stream: _flights,
              builder: (context, snapshot) {
                final flights = snapshot.data;
                if (flights == null) return const VkSpinner();
                if (flights.isEmpty) {
                  return VkPlaceholder(
                    icon: Icons.event_busy_rounded,
                    header: 'Рейсов нет',
                    text:
                        'На ${formatDayMonth(_date)} ещё ничего не запланировано',
                    action: VkButton(
                      text: 'Добавить рейс',
                      size: VkButtonSize.m,
                      onPressed: () =>
                          pushPage<void>(context, FlightFormPage(date: _date)),
                    ),
                  );
                }
                final entries = flights.indexed.toList()
                  ..sort(
                    (a, b) =>
                        a.$2.departureMinutes.compareTo(b.$2.departureMinutes),
                  );
                return ListView(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    12,
                    12,
                    MediaQuery.paddingOf(context).bottom + 12,
                  ),
                  children: [
                    for (final (index, flight) in entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FlightCard(
                          flight: flight,
                          actions: Row(
                            children: [
                              VkButton(
                                text: 'Изменить',
                                mode: VkButtonMode.tertiary,
                                size: VkButtonSize.m,
                                before: const Icon(Icons.edit_outlined),
                                onPressed: () => pushPage<void>(
                                  context,
                                  FlightFormPage(
                                    date: _date,
                                    flight: flight,
                                    index: index,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              VkButton(
                                text: 'Удалить',
                                mode: VkButtonMode.tertiary,
                                size: VkButtonSize.m,
                                negative: true,
                                before: const Icon(
                                  Icons.delete_outline_rounded,
                                ),
                                onPressed: () => _delete(index, flight),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _dialogAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
  bool destructive = false,
}) {
  if (context.isIOS) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      isDestructiveAction: destructive,
      child: child,
    );
  }
  return TextButton(
    onPressed: onPressed,
    style: destructive
        ? TextButton.styleFrom(foregroundColor: context.vk.textNegative)
        : null,
    child: child,
  );
}

/// Horizontal list of days, like the VKUI calendar header.
class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.days,
    required this.today,
    required this.selected,
    required this.onSelected,
  });

  final List<DateTime> days;
  final DateTime today;
  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: vk.backgroundContent,
        border: Border(
          bottom: BorderSide(color: vk.separatorPrimaryAlpha, width: 0.5),
        ),
      ),
      child: SizedBox(
        height: 76,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: days.length,
          separatorBuilder: (_, _) => const SizedBox(width: 6),
          itemBuilder: (context, i) {
            final day = days[i];
            final isSelected = day == selected;
            final isToday = day == today;
            return Material(
              color: isSelected ? vk.backgroundAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onSelected(day),
                child: SizedBox(
                  width: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isToday ? 'сег' : formatWeekdayShort(day),
                        style: VkTypography.caption1.copyWith(
                          color: isSelected ? Colors.white70 : vk.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day.day}',
                        style: VkTypography.title3.copyWith(
                          color: isSelected
                              ? Colors.white
                              : isToday
                              ? vk.textAccent
                              : vk.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
