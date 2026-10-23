import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/badges.dart';
import '../components/flight_card.dart';
import '../components/panel_header.dart';
import '../components/placeholder.dart';
import '../components/spinner.dart';
import '../components/vk_icon.dart';
import '../data/avia_repository.dart';
import '../data/flight.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/formatters.dart';
import 'app_drawer.dart';
import 'flight_details_sheet.dart';

/// Passenger board: today's and tomorrow's flights, updated in real time.
class BoardPage extends StatefulWidget {
  const BoardPage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<BoardPage> createState() => BoardPageState();
}

class BoardPageState extends State<BoardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _today = dateOnly(DateTime.now());

  late final List<DateTime> _days = [
    _today,
    _today.add(const Duration(days: 1)),
  ];

  // Separate subscriptions for the tab counters and the lists: repository
  // streams are single-subscription.
  late final List<Stream<List<Flight>>> _counters;
  late final List<Stream<List<Flight>>> _lists;

  @override
  void initState() {
    super.initState();
    final repository = context.read<AviaRepository>();
    _counters = _days.map(repository.watchFlights).toList();
    _lists = _days.map(repository.watchFlights).toList();
  }

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  Future<void> showDetails(Flight flight, {int day = 0}) =>
      showFlightDetails(context, flight: flight, date: _days[day]);

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return DefaultTabController(
      length: _days.length,
      initialIndex: widget.initialTab,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: vk.background,
        drawer: const AppDrawer(),
        appBar: VkPanelHeader(
          title: 'Табло',
          leading: VkHeaderButton(
            tooltip: 'Меню',
            onPressed: openDrawer,
            child: VkIcon('menu', color: vk.iconAccent),
          ),
          bottom: TabBar(
            tabs: [_tab('Сегодня', _counters[0]), _tab('Завтра', _counters[1])],
          ),
        ),
        body: TabBarView(
          children: [
            for (var i = 0; i < _days.length; i++)
              _FlightsTab(
                date: _days[i],
                flights: _lists[i],
                onTap: (flight) => showDetails(flight, day: i),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, Stream<List<Flight>> flights) {
    return Tab(
      height: 44,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          StreamBuilder<List<Flight>>(
            stream: flights,
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              if (count == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: VkCounter(count),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FlightsTab extends StatefulWidget {
  const _FlightsTab({
    required this.date,
    required this.flights,
    required this.onTap,
  });

  final DateTime date;
  final Stream<List<Flight>> flights;
  final ValueChanged<Flight> onTap;

  @override
  State<_FlightsTab> createState() => _FlightsTabState();
}

class _FlightsTabState extends State<_FlightsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Flight>>(
      stream: widget.flights,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const VkPlaceholder(
            icon: Icons.wifi_off_rounded,
            header: 'Не удалось загрузить табло',
            text: 'Проверьте подключение к интернету',
          );
        }
        final flights = snapshot.data;
        if (flights == null) return const VkSpinner();
        if (flights.isEmpty) {
          return VkPlaceholder(
            icon: Icons.flight_takeoff_rounded,
            header: 'Рейсов пока нет',
            text:
                'Расписание на ${formatDayMonth(widget.date)} появится, '
                'как только диспетчер его опубликует',
          );
        }
        final sorted = [...flights]
          ..sort((a, b) => a.departureMinutes.compareTo(b.departureMinutes));
        return ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 12,
          ),
          children: [
            _DayHeader(date: widget.date, count: flights.length),
            for (final flight in sorted)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: FlightCard(
                  flight: flight,
                  onTap: () => widget.onTap(flight),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.date, required this.count});

  final DateTime date;
  final int count;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatFullDate(date),
            style: VkTypography.title2.copyWith(color: vk.textPrimary),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: vk.textPositive,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${formatFlightsCount(count)} · обновляется онлайн',
                style: VkTypography.footnote.copyWith(color: vk.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
