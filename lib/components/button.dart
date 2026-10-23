import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';

enum VkButtonMode { primary, secondary, tertiary }

enum VkButtonSize { m, l }

/// VKUI `Button`.
class VkButton extends StatelessWidget {
  const VkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.mode = VkButtonMode.primary,
    this.size = VkButtonSize.l,
    this.before,
    this.stretched = false,
    this.loading = false,
    this.negative = false,
  });

  final String text;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final VkButtonMode mode;
  final VkButtonSize size;
  final Widget? before;
  final bool stretched;
  final bool loading;

  /// Red appearance for destructive actions.
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final enabled = onPressed != null && !loading;
    final (Color background, Color foreground) = switch (mode) {
      VkButtonMode.primary =>
        negative
            ? (vk.textNegative, Colors.white)
            : (vk.backgroundAccentThemed, vk.textContrastThemed),
      VkButtonMode.secondary => (
        vk.backgroundSecondaryAlpha,
        negative ? vk.textNegative : vk.textAccentThemed,
      ),
      VkButtonMode.tertiary => (
        Colors.transparent,
        negative ? vk.textNegative : vk.textAccentThemed,
      ),
    };
    final height = size == VkButtonSize.l ? 44.0 : 36.0;
    final radius = BorderRadius.circular(size == VkButtonSize.l ? 10 : 8);

    final label = Row(
      mainAxisSize: stretched ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (before != null) ...[
          IconTheme(
            data: IconThemeData(color: foreground, size: 20),
            child: before!,
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                (size == VkButtonSize.l
                        ? VkTypography.headline1
                        : VkTypography.headline2)
                    .copyWith(color: foreground),
          ),
        ),
      ],
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled || loading ? 1 : 0.48,
      child: SizedBox(
        height: height,
        width: stretched ? double.infinity : null,
        child: Material(
          color: background,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            splashColor: foreground.withValues(alpha: 0.12),
            highlightColor: foreground.withValues(alpha: 0.08),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size == VkButtonSize.l ? 20 : 16,
              ),
              child: Center(
                widthFactor: 1,
                child: loading
                    ? CupertinoActivityIndicator(color: foreground)
                    : label,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
