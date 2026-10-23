import 'package:flutter/material.dart';

import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';

/// VKUI `FormItem`: a field with a label on top and an optional status below.
class VkFormItem extends StatelessWidget {
  const VkFormItem({
    super.key,
    required this.top,
    required this.child,
    this.bottom,
    this.error = false,
  });

  final String top;
  final Widget child;

  /// Hint or error text under the field.
  final String? bottom;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              top,
              style: VkTypography.subhead.copyWith(color: vk.textSubhead),
            ),
          ),
          child,
          if (bottom != null && bottom!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                bottom!,
                style: VkTypography.footnote.copyWith(
                  color: error ? vk.textNegative : vk.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
