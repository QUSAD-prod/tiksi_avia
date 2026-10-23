import 'package:flutter/cupertino.dart';

/// Pushes a page with the iOS-style slide and swipe-back on every platform,
/// like VKUI `View` transitions.
Future<T?> pushPage<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push(CupertinoPageRoute<T>(builder: (_) => page));

Future<T?> replacePage<T>(BuildContext context, Widget page) => Navigator.of(
  context,
).pushReplacement(CupertinoPageRoute<T>(builder: (_) => page));
