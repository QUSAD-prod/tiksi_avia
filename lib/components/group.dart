import 'package:flutter/material.dart';

import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';

/// VKUI `Group` in card mode: a rounded block on the page background.
class VkGroup extends StatelessWidget {
  const VkGroup({
    super.key,
    this.header,
    required this.children,
    this.footer,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
  });

  final String? header;
  final List<Widget> children;
  final String? footer;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) VkHeader(header!),
          VkCard(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
          if (footer != null) VkFooter(footer!),
        ],
      ),
    );
  }
}

/// Rounded content surface with the VKUI `elevation1` shadow.
class VkCard extends StatelessWidget {
  const VkCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final radius = BorderRadius.circular(12);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: vk.shadow,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: vk.backgroundContent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// VKUI `Header mode="secondary"`.
class VkHeader extends StatelessWidget {
  const VkHeader(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: VkTypography.footnoteCaps.copyWith(
                color: context.vk.textSecondary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// VKUI `Footer`: a hint under a group.
class VkFooter extends StatelessWidget {
  const VkFooter(this.text, {super.key, this.textAlign = TextAlign.start});

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        text,
        textAlign: textAlign,
        style: VkTypography.footnote.copyWith(color: context.vk.textSecondary),
      ),
    );
  }
}
