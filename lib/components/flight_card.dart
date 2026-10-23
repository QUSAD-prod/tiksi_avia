import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/flight.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/formatters.dart';
import 'badges.dart';
import 'group.dart';

/// A flight on the board: route, status, departure → arrival.
class FlightCard extends StatelessWidget {
  const FlightCard({super.key, required this.flight, this.onTap, this.actions});

  final Flight flight;
  final VoidCallback? onTap;

  /// Dispatcher actions, shown under a separator.
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final route = flight.route;
    return VkCard(
      onTap: onTap,
      padding: EdgeInsets.fromLTRB(16, 14, 16, actions == null ? 16 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.title,
                      style: VkTypography.title3.copyWith(
                        color: vk.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      flight.company,
                      style: VkTypography.subhead.copyWith(
                        color: vk.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: StatusBadge(flight.status),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FlightTimeline(flight: flight, background: vk.backgroundContent),
          if (actions != null) ...[
            const SizedBox(height: 12),
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: vk.separatorPrimaryAlpha,
            ),
            actions!,
          ],
        ],
      ),
    );
  }
}

/// Departure time and place → flight path → arrival time and place.
class FlightTimeline extends StatelessWidget {
  const FlightTimeline({
    super.key,
    required this.flight,
    required this.background,
  });

  final Flight flight;

  /// Color behind the plane icon; must match the surface the timeline is on.
  final Color background;

  @override
  Widget build(BuildContext context) {
    final route = flight.route;
    return Row(
      children: [
        _TimePlace(
          time: displayTime(flight.departure),
          place: route.from,
          alignment: CrossAxisAlignment.start,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FlightPath(
              duration: flight.duration,
              background: background,
            ),
          ),
        ),
        _TimePlace(
          time: displayTime(flight.arrival),
          place: route.to,
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}

class _TimePlace extends StatelessWidget {
  const _TimePlace({
    required this.time,
    required this.place,
    required this.alignment,
  });

  final String time;
  final String place;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            time,
            style: VkTypography.title1.copyWith(
              color: vk.textPrimary,
              fontFeatures: VkTypography.tabular,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            place,
            maxLines: 2,
            textAlign: alignment == CrossAxisAlignment.end
                ? TextAlign.end
                : TextAlign.start,
            style: VkTypography.footnote.copyWith(color: vk.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Dashed track with a plane in the middle and the flight time above it.
class FlightPath extends StatelessWidget {
  const FlightPath({
    super.key,
    required this.duration,
    required this.background,
  });

  final Duration? duration;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          duration == null ? '' : formatDuration(duration!),
          maxLines: 1,
          style: VkTypography.caption1.copyWith(color: vk.textSecondary),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 18,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TrackPainter(
                    line: vk.separatorPrimary,
                    accent: vk.iconAccent,
                  ),
                ),
              ),
              ColoredBox(
                color: background,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Transform.rotate(
                    angle: math.pi / 2,
                    child: Icon(
                      Icons.flight_rounded,
                      size: 18,
                      color: vk.iconAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrackPainter extends CustomPainter {
  const _TrackPainter({required this.line, required this.accent});

  final Color line;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    const dot = 3.5;
    final dash = Paint()
      ..color = line
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (double x = dot * 2 + 2; x < size.width - dot * 2 - 2; x += 7) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + 3, size.width), y),
        dash,
      );
    }
    canvas
      ..drawCircle(
        Offset(dot, y),
        dot - 0.75,
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      )
      ..drawCircle(Offset(size.width - dot, y), dot, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(_TrackPainter old) =>
      old.line != line || old.accent != accent;
}
