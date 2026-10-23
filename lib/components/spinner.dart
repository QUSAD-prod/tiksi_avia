import 'package:flutter/material.dart';

import '../theme/vk_colors.dart';
import 'vk_icon.dart';

/// VKUI `Spinner` (large).
class VkSpinner extends StatefulWidget {
  const VkSpinner({super.key, this.size = 44});

  final double size;

  @override
  State<VkSpinner> createState() => _VkSpinnerState();
}

class _VkSpinnerState extends State<VkSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: VkIcon(
          'spinner',
          size: widget.size,
          color: context.vk.iconSecondary,
        ),
      ),
    );
  }
}
