import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'board_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    this.duration = const Duration(milliseconds: 1800),
  });

  final Duration duration;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, _openBoard);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _openBoard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, _, _) => const BoardPage(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark ? const Color(0xFF0E1A24) : const Color(0xFFD7E8F2);
    final map = dark ? const Color(0xFF15283A) : const Color(0xFFCADDEA);
    final title = dark ? Colors.white : const Color(0xFF0C122A);
    final subtitle = title.withValues(alpha: 0.6);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: width * 0.1,
                      bottom: width * 0.2,
                    ),
                    child: SvgPicture.asset(
                      'assets/world_location_map.svg',
                      fit: BoxFit.fitWidth,
                      colorFilter: ColorFilter.mode(map, BlendMode.srcIn),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: width * 0.12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.07),
                        child: Image.asset(
                          'assets/tiksiAviaBig.png',
                          width: width * 0.3,
                          height: width * 0.3,
                        ),
                      ),
                      SizedBox(height: width * 0.08),
                      SvgPicture.asset('assets/plane.svg', width: width * 0.8),
                      SizedBox(height: width * 0.06),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Tiksi ',
                              style: TextStyle(color: title),
                            ),
                            const TextSpan(
                              text: 'Avia',
                              style: TextStyle(color: Color(0xFF2E91C8)),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.11,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: width * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.12),
                        child: Text(
                          'Онлайн-табло самолётов и вертолётов',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: width * 0.055,
                            height: 1.3,
                            color: subtitle,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'by Oslopov',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: title,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
