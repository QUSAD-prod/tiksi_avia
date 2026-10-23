import 'package:flutter/material.dart';

import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';

/// VKUI `Placeholder`: empty states with an icon, a header, text and an action.
class VkPlaceholder extends StatelessWidget {
  const VkPlaceholder({
    super.key,
    required this.icon,
    required this.header,
    this.text,
    this.action,
  });

  final IconData icon;
  final String header;
  final String? text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: vk.iconTertiary),
            const SizedBox(height: 12),
            Text(
              header,
              textAlign: TextAlign.center,
              style: VkTypography.title2.copyWith(color: vk.textPrimary),
            ),
            if (text != null) ...[
              const SizedBox(height: 8),
              Text(
                text!,
                textAlign: TextAlign.center,
                style: VkTypography.text.copyWith(color: vk.textSecondary),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
