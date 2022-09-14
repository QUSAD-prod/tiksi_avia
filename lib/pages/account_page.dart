import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiksi_avia/components/button.dart';
import 'package:tiksi_avia/components/route_aware.dart';
import 'package:tiksi_avia/pages/add_page.dart';
import 'package:tiksi_avia/pages/change_page.dart';
import 'fb.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends RouteAwareState<AccountPage> {
  late Fb fb;

  @override
  void initState() {
    super.initState();
    fb = Fb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin панель"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(
                "assets/back_arrow.svg",
                color: Theme.of(context).appBarTheme.iconTheme!.color,
                height: 28,
                width: 28,
              ),
              iconSize: 28,
              splashRadius: 20,
            );
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: Button(
                text: "Редактировать рейсы",
                icon: SvgPicture.asset(
                  "assets/pen_icon.svg",
                  width: 15,
                  height: 15,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
                onClick: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => const ChangePage()),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: Button(
                text: "Добавить рейс",
                icon: SvgPicture.asset(
                  "assets/add_icon.svg",
                  width: 16,
                  height: 16,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
                onClick: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => const AddPage()),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              height: 0.5,
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFD7D8D9)
                  : const Color(0xFF363738),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Button(
                text: "Выйти из аккаунта",
                icon: SvgPicture.asset(
                  'assets/user_outline_icon.svg',
                  width: 16,
                  height: 16,
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFE64646)
                      : const Color(0xFFFF5C5C),
                ),
                onClick: () => signOut(fb.signOut()),
                textButtonColor:
                    Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFFE64646)
                        : const Color(0xFFFF5C5C),
                mode: ButtonMode.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  signOut(Future<String> result) async {
    await result.then(
      (value) {
        switch (value) {
          case 'ok':
            showSnackBar(
              text: "Вы успешно вышли из аккаунта",
              context: context,
              icon: SvgPicture.asset(
                "assets/icon_done.svg",
                color: const Color(0xFF4BB34B),
              ),
            );
            Navigator.pop(context);
            break;
          default:
            showSnackBar(
              text: "Неизвестная ошибка",
              icon: SvgPicture.asset(
                "assets/icon_cancel.svg",
                color: const Color(0xFFE64646),
              ),
              context: context,
            );
        }
      },
    );
  }

  showSnackBar({
    required String text,
    Widget? icon,
    required BuildContext context,
  }) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: icon == null
          ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)
          : const EdgeInsets.only(
              left: 12.0, right: 16.0, top: 12.0, bottom: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      content: Row(
        children: [
          Container(
            margin: icon == null
                ? const EdgeInsets.all(0.0)
                : const EdgeInsets.only(right: 12.0),
            child: icon ?? const SizedBox(width: 0, height: 0),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void onEnterScreen() {}

  @override
  void onLeaveScreen() {}
}
