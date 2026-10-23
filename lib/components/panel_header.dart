import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/vk_colors.dart';
import 'vk_icon.dart';

/// VKUI `PanelHeader`: centered title on iOS, left-aligned on Android.
class VkPanelHeader extends StatelessWidget implements PreferredSizeWidget {
  const VkPanelHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.separator = true,
  });

  final String title;

  /// Defaults to [VkBackButton].
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool separator;

  @override
  Size get preferredSize =>
      Size.fromHeight(52 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return AppBar(
      leading: leading ?? const VkBackButton(),
      title: Text(title),
      // AppBar stops centering on iOS when there are two or more actions.
      centerTitle: context.isIOS,
      actions: [...?actions, const SizedBox(width: 4)],
      bottom: bottom,
      shape: separator && bottom == null
          ? Border(
              bottom: BorderSide(color: vk.separatorPrimaryAlpha, width: 0.5),
            )
          : null,
    );
  }
}

class VkBackButton extends StatelessWidget {
  const VkBackButton({super.key});

  @override
  Widget build(BuildContext context) => VkHeaderButton(
    tooltip: 'Назад',
    onPressed: () => Navigator.maybePop(context),
    child: context.isIOS
        ? Icon(CupertinoIcons.back, size: 28, color: context.vk.iconAccent)
        : VkIcon('back_arrow', color: context.vk.iconAccent),
  );
}

/// Icon button of the panel header (`PanelHeaderButton`).
class VkHeaderButton extends StatelessWidget {
  const VkHeaderButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: child,
    iconSize: 28,
    style: IconButton.styleFrom(overlayColor: context.vk.iconAccent),
  );
}
