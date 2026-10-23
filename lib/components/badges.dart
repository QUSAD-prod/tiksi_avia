import 'package:flutter/material.dart';

import '../data/flight.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';

/// Colored pill with the dispatcher's status of a flight.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key, this.large = false});

  final String status;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final (background, foreground) = switch (StatusTone.of(status)) {
      StatusTone.positive => (vk.backgroundPositiveTint, vk.textPositive),
      StatusTone.accent => (vk.backgroundInfoTint, vk.textAccent),
      StatusTone.warning => (vk.backgroundWarning, vk.textWarning),
      StatusTone.negative => (vk.backgroundNegativeTint, vk.textNegative),
      StatusTone.neutral => (vk.backgroundSecondaryAlpha, vk.textSubhead),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 10 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(large ? 10 : 8),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: (large ? VkTypography.subhead : VkTypography.caption1).copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// VKUI `Counter` (secondary mode).
class VkCounter extends StatelessWidget {
  const VkCounter(this.value, {super.key, this.accent = false});

  final int value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: accent ? vk.backgroundAccent : vk.backgroundSecondaryAlpha,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        '$value',
        style: VkTypography.caption1.copyWith(
          fontWeight: FontWeight.w600,
          color: accent ? Colors.white : vk.textSubhead,
        ),
      ),
    );
  }
}
