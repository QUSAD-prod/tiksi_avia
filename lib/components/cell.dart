import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';

/// VKUI `SimpleCell`.
class VkSimpleCell extends StatelessWidget {
  const VkSimpleCell({
    super.key,
    required this.title,
    this.subtitle,
    this.before,
    this.after,
    this.indicator,
    this.onTap,
    this.chevron = false,
    this.destructive = false,
  });

  final String title;
  final String? subtitle;
  final Widget? before;
  final Widget? after;

  /// Secondary text in front of [after], e.g. the current value of a setting.
  final String? indicator;
  final VoidCallback? onTap;
  final bool chevron;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: subtitle == null ? 10 : 8,
          ),
          child: Row(
            children: [
              if (before != null) ...[
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 28),
                  child: before,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: VkTypography.text.copyWith(
                        color: destructive ? vk.textNegative : vk.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: VkTypography.footnote.copyWith(
                          color: vk.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (indicator != null) ...[
                const SizedBox(width: 8),
                Text(
                  indicator!,
                  style: VkTypography.text.copyWith(color: vk.textSecondary),
                ),
              ],
              if (after != null) ...[const SizedBox(width: 8), after!],
              if (chevron) ...[
                const SizedBox(width: 4),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: vk.iconTertiary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// `SimpleCell` with a `Switch`. While [loading], a spinner replaces the switch.
class VkSwitchCell extends StatelessWidget {
  const VkSwitchCell({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.before,
    this.loading = false,
  });

  final String title;
  final String? subtitle;
  final Widget? before;
  final bool value;
  final bool loading;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VkSimpleCell(
      title: title,
      subtitle: subtitle,
      before: before,
      onTap: loading ? null : () => onChanged(!value),
      after: loading
          ? const SizedBox(
              width: 51,
              height: 31,
              child: Center(child: CupertinoActivityIndicator()),
            )
          : Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: context.vk.backgroundAccent,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
    );
  }
}

/// Circle with an icon, used as `before` of cells (VKUI `IconButton`-like avatar).
class VkIconAvatar extends StatelessWidget {
  const VkIconAvatar({
    super.key,
    required this.child,
    required this.color,
    this.size = 28,
  });

  final Widget child;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(size * 0.3),
    ),
    alignment: Alignment.center,
    child: child,
  );
}
