import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/button.dart';
import '../components/cell.dart';
import '../components/form.dart';
import '../components/group.dart';
import '../components/input.dart';
import '../components/panel_header.dart';
import '../components/snackbar.dart';
import '../data/avia_repository.dart';
import '../data/flight.dart';
import '../data/flight_route.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/formatters.dart';
import 'flights_editor_page.dart';

/// Adds a flight, or edits the times and status of an existing one.
class FlightFormPage extends StatefulWidget {
  const FlightFormPage({super.key, this.date, this.flight, this.index});

  /// Day of the flight, today by default.
  final DateTime? date;

  /// Values to start from. Together with [index] the page edits that flight.
  final Flight? flight;
  final int? index;

  bool get isEditing => index != null;

  static const statusPresets = [
    'По расписанию',
    'Регистрация',
    'Идёт посадка',
    'Вылетел',
    'Прибыл',
    'Задерживается',
    'Отменён',
  ];

  @override
  State<FlightFormPage> createState() => _FlightFormPageState();
}

class _FlightFormPageState extends State<FlightFormPage> {
  late DateTime _date = dateOnly(widget.date ?? DateTime.now());
  late FlightRoute _route = widget.flight?.route ?? FlightRoute.all.first;
  late final _company = TextEditingController(text: widget.flight?.company);
  late final _status = TextEditingController(text: widget.flight?.status);
  late TimeOfDay? _departure = parseTime(widget.flight?.departure ?? '');
  late TimeOfDay? _arrival = parseTime(widget.flight?.arrival ?? '');
  bool _saving = false;

  bool get _valid =>
      _company.text.trim().isNotEmpty &&
      _status.text.trim().isNotEmpty &&
      _departure != null &&
      _arrival != null;

  Duration? get _duration {
    final from = _departure, to = _arrival;
    if (from == null || to == null) return null;
    var minutes = (to.hour * 60 + to.minute) - (from.hour * 60 + from.minute);
    if (minutes < 0) minutes += 24 * 60;
    return Duration(minutes: minutes);
  }

  @override
  void dispose() {
    _company.dispose();
    _status.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: FlightsEditorPage.firstDate,
      lastDate: today.add(const Duration(days: 7)),
      helpText: 'Дата рейса',
    );
    if (date != null) setState(() => _date = dateOnly(date));
  }

  Future<void> _pickTime({required bool departure}) async {
    final current = departure ? _departure : _arrival;
    final time = await showTimePicker(
      context: context,
      initialTime:
          current ?? _departure ?? const TimeOfDay(hour: 12, minute: 0),
      helpText: departure ? 'Время вылета' : 'Время прилёта',
      cancelText: 'Отмена',
      confirmText: 'Готово',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (time == null) return;
    setState(() => departure ? _departure = time : _arrival = time);
  }

  Future<void> _pickRoute() async {
    final route = await showModalBottomSheet<FlightRoute>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _RoutePicker(selected: _route),
    );
    if (route != null) setState(() => _route = route);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final flight = Flight(
      name: _route.name,
      company: _company.text.trim(),
      departure: formatTime(_departure!),
      arrival: formatTime(_arrival!),
      status: _status.text.trim(),
    );
    final repository = context.read<AviaRepository>();
    setState(() => _saving = true);
    try {
      if (widget.isEditing) {
        await repository.updateFlight(_date, widget.index!, flight);
      } else {
        await repository.addFlight(_date, flight);
      }
      if (!mounted) return;
      showVkSnackbar(
        context,
        widget.isEditing ? 'Изменения сохранены' : 'Рейс добавлен на табло',
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showErrorSnackbar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final duration = _duration;
    return Scaffold(
      appBar: VkPanelHeader(
        title: widget.isEditing ? 'Редактирование' : 'Новый рейс',
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            if (widget.isEditing) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: vk.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Дата', value: formatFullDate(_date)),
                    _SummaryRow(label: 'Маршрут', value: _route.title),
                    _SummaryRow(label: 'Авиакомпания', value: _company.text),
                  ],
                ),
              ),
              const VkFooter(
                'Чтобы сменить дату или направление, удалите рейс и добавьте его заново',
              ),
              const SizedBox(height: 6),
            ] else ...[
              VkFormItem(
                top: 'Дата',
                child: VkSelectField(
                  value: formatFullDate(_date),
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
              ),
              VkFormItem(
                top: 'Направление',
                child: VkSelectField(value: _route.title, onTap: _pickRoute),
              ),
              VkFormItem(
                top: 'Авиакомпания',
                child: VkInput(
                  controller: _company,
                  placeholder: 'Например, Полярные авиалинии',
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: VkFormItem(
                    top: 'Вылет',
                    child: VkSelectField(
                      value: _departure == null
                          ? null
                          : formatTime(_departure!),
                      placeholder: 'Выбрать',
                      icon: Icons.schedule_rounded,
                      onTap: () => _pickTime(departure: true),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VkFormItem(
                    top: 'Прилёт',
                    child: VkSelectField(
                      value: _arrival == null ? null : formatTime(_arrival!),
                      placeholder: 'Выбрать',
                      icon: Icons.schedule_rounded,
                      onTap: () => _pickTime(departure: false),
                    ),
                  ),
                ),
              ],
            ),
            if (duration != null)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 4),
                child: Text(
                  'В пути ${formatDuration(duration)}',
                  style: VkTypography.footnote.copyWith(
                    color: vk.textSecondary,
                  ),
                ),
              ),
            VkFormItem(
              top: 'Статус',
              child: VkInput(
                controller: _status,
                placeholder: 'Например, По расписанию',
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in FlightFormPage.statusPresets)
                  _Chip(
                    text: preset,
                    selected: _status.text.trim() == preset,
                    onTap: () => setState(() => _status.text = preset),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            VkButton(
              text: widget.isEditing ? 'Сохранить изменения' : 'Добавить рейс',
              stretched: true,
              loading: _saving,
              onPressed: _valid ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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

/// VKUI `SubnavigationButton`-like chip for quick status input.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Material(
      color: selected ? vk.backgroundAccent : vk.backgroundSecondaryAlpha,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(
            text,
            style: VkTypography.subhead.copyWith(
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : vk.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoutePicker extends StatelessWidget {
  const _RoutePicker({required this.selected});

  final FlightRoute selected;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    Widget cell(FlightRoute route) => VkSimpleCell(
      title: route.title,
      after: route.name == selected.name
          ? Icon(Icons.check_rounded, color: vk.iconAccent)
          : null,
      onTap: () => Navigator.of(context).pop(route),
    );
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Направление',
              style: VkTypography.title2.copyWith(color: vk.textPrimary),
            ),
          ),
          const VkHeader('Из Тикси'),
          ...FlightRoute.outbound.map(cell),
          const VkHeader('В Тикси'),
          ...FlightRoute.inbound.map(cell),
        ],
      ),
    );
  }
}
