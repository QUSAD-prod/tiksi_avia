import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// VK icon from `assets/`, tinted with a single color.
class VkIcon extends StatelessWidget {
  const VkIcon(this.asset, {super.key, this.size = 28, required this.color});

  final String asset;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/$asset.svg',
    width: size,
    height: size,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}
