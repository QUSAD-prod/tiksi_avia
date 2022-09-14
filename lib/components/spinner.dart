import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Spinner extends StatefulWidget {
  const Spinner({Key? key}) : super(key: key);

  @override
  SpinnerState createState() => SpinnerState();
}

class SpinnerState extends State<Spinner> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          "assets/spinner.svg",
          height: 44,
          width: 44,
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
