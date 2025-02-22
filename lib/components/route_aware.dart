import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';


abstract class RouteAwareState<T extends StatefulWidget> extends State<T>
    with RouteAware, AfterLayoutMixin<T> {
  late RouteObserver<PageRoute>? routeObserver;
  bool enteredScreen = false;
  // use `afterFirstLayout()`, because we should wait for
  // the `initState() completed before getting objects from `context`
  @override
  // add @mustCallSuper annotation to prevent being overridden
  @mustCallSuper
  void afterFirstLayout(BuildContext context) {
    if (mounted) {
      // get the instance of `RouteObserver` from `context`
      routeObserver = context.read<RouteObserver<PageRoute>>();
      // subscribe for the change of route
      routeObserver?.subscribe(this, ModalRoute.of(context) as PageRoute);
      // execute asynchronously as soon as possible
      Timer.run(_enterScreen);
    }
  }

  void _enterScreen() {
    onEnterScreen();
    enteredScreen = true;
  }

  void _leaveScreen() {
    onLeaveScreen();
    enteredScreen = false;
  }

  @override
  @mustCallSuper
  void dispose() {
    if (enteredScreen) {
      _leaveScreen();
    }
    routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  @mustCallSuper
  void didPopNext() {
    Timer.run(_enterScreen);
  }

  @override
  @mustCallSuper
  void didPop() {
    _leaveScreen();
  }

  @override
  @mustCallSuper
  void didPushNext() {
    _leaveScreen();
  }

  /// this method will always be executed on enter this screen
  void onEnterScreen();

  /// this method will always be executed on leaving this screen
  void onLeaveScreen();
}
