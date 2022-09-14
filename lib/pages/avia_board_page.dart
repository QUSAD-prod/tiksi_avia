import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tiksi_avia/components/date_changer.dart';
import 'package:tiksi_avia/components/drawer_button.dart';
import 'package:tiksi_avia/components/list_item.dart';
import 'package:tiksi_avia/components/route_aware.dart';
import 'package:tiksi_avia/components/spinner.dart';
import 'package:tiksi_avia/components/text.dart';
import 'package:tiksi_avia/pages/auth_page.dart';
import 'package:tiksi_avia/pages/settings_page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'account_page.dart';
import 'fb.dart';

class AviaBoardPage extends StatefulWidget {
  const AviaBoardPage({Key? key}) : super(key: key);

  @override
  AviaBoardPageState createState() => AviaBoardPageState();
}

class AviaBoardPageState extends RouteAwareState<AviaBoardPage> {
  Box data = Hive.box('data');
  Box settings = Hive.box('settings');
  DateTime currentDate = DateTime.now();
  int selectedEl = 0;
  PageController pageChangeController = PageController(initialPage: 0);
  Fb fb = Fb();

  String getPath(DateTime currentDate) {
    return "${currentDate.day.toString()}-${currentDate.month.toString()}-${currentDate.year.toString()}";
  }

  late DatabaseReference databaseReferenceNow;
  late DatabaseReference databaseReferenceNext;

  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  void onEnterScreen() {}

  @override
  void onLeaveScreen() {}

  @override
  void initState() {
    super.initState();
    data.get(getPath(currentDate), defaultValue: []) == [0]
        ? data.put(getPath(currentDate), [])
        : null;
    data.get(getPath(currentDate.add(const Duration(days: 1))),
                defaultValue: []) ==
            [0]
        ? data.put(getPath(currentDate.add(const Duration(days: 1))), [])
        : null;
    databaseReferenceNow =
        FirebaseDatabase.instance.ref().child(getPath(currentDate));
    databaseReferenceNext = FirebaseDatabase.instance
        .ref()
        .child(getPath(currentDate.add(const Duration(days: 1))));
    databaseReferenceNow.onValue.listen(
      (event) {
        data.put(getPath(currentDate), []);
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          List<Map<dynamic, dynamic>> data = List.from(snapshot.value as List);
          this.data.put(getPath(currentDate), data);
        } else {
          data.put(getPath(currentDate), [0]);
        }
      },
    );
    databaseReferenceNext.onValue.listen(
      (event) {
        data.put(getPath(currentDate.add(const Duration(days: 1))), []);
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          List<Map<dynamic, dynamic>> data = List.from(snapshot.value as List);
          this
              .data
              .put(getPath(currentDate.add(const Duration(days: 1))), data);
        } else {
          data.put(getPath(currentDate.add(const Duration(days: 1))), [0]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    bool auth = fb.isAuthenticated();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Табло"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset(
                "assets/menu.svg",
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
      drawer: Drawer(
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: 4,
                right: 4,
                left: 4,
              ),
              child: Column(
                children: [
                  Container(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 16, left: 12),
                        child: Image.asset(
                          "assets/tiksiAvia.png",
                          width: height * 0.1,
                          height: height * 0.1,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "TiksiAvia",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "by Oslopov",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color(0xFF6D7885)
                                  : const Color(0xFF909499),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  Container(
                    height: 16,
                  ),
                  DrawerButton(
                    icon: SvgPicture.asset(
                      "assets/user_icon.svg",
                      color: Theme.of(context).appBarTheme.iconTheme!.color,
                      width: 28,
                      height: 28,
                    ),
                    text: auth ? "Admin панель" : "Войти в аккаунт",
                    onClick: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              auth ? const AccountPage() : const AuthPage(),
                        ),
                      );
                    },
                  ),
                  DrawerButton(
                    icon: SvgPicture.asset(
                      "assets/settings_icon.svg",
                      color: Theme.of(context).appBarTheme.iconTheme!.color,
                      width: 28,
                      height: 28,
                    ),
                    text: "Настройки",
                    onClick: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  Expanded(child: Container()),
                  getSeporator(),
                  Row(
                    children: [
                      Expanded(
                        child: DrawerButton(
                          icon: SvgPicture.asset(
                            'assets/all_categories_icon.svg',
                            color:
                                Theme.of(context).appBarTheme.iconTheme!.color,
                            width: 28,
                            height: 28,
                          ),
                          fontSize: 16,
                          text: "Другие приложения",
                          onClick: () => _launchURL(),
                        ),
                      ),
                      Container(
                        width: 16,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onLongPress: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const SettingsPage())),
                          onTap: () =>
                              Theme.of(context).brightness == Brightness.light
                                  ? settings.put('theme', 'dark')
                                  : settings.put('theme', 'light'),
                          child: Container(
                            width: 36,
                            height: 36,
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(
                              Theme.of(context).brightness == Brightness.light
                                  ? 'assets/moon_icon.svg'
                                  : 'assets/sun_icon.svg',
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme!
                                  .color,
                              height: 28,
                              width: 28,
                            ),
                          ),
                        ),
                      ),
                      Container(width: 6),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFEBEDF0)
            : const Color(0xFF0A0A0A),
        child: Column(
          children: [
            DateChanger(
              value: selectedEl,
              onTap: () => setState(
                () {
                  selectedEl == 0 ? selectedEl = 1 : selectedEl = 0;
                  pageChangeController.animateToPage(
                    selectedEl,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (int i) {
                    setState(() {
                      selectedEl = i;
                    });
                  },
                  controller: pageChangeController,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: data.listenable(),
                      builder: (BuildContext context, Box box, Widget? widget) {
                        List temp = box.get(
                          getPath(currentDate),
                          defaultValue: [],
                        );
                        return temp.isNotEmpty
                            ? temp[0] == 0
                                ? const Center(
                                    child: SecondaryText(
                                      text: "На сегодня рейсов не найдено",
                                    ),
                                  )
                                : ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: temp.length,
                                      itemBuilder:
                                          (BuildContext context, int id) {
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(top: 12.0),
                                          child: VkListItem(data: temp[id]),
                                        );
                                      },
                                    ),
                                  )
                            : const Center(
                                child: Spinner(),
                              );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: data.listenable(),
                      builder: (BuildContext context, Box box, Widget? widget) {
                        List temp = box.get(
                          getPath(currentDate.add(const Duration(days: 1))),
                          defaultValue: [],
                        );
                        return temp.isNotEmpty
                            ? temp[0] == 0
                                ? const Center(
                                    child: SecondaryText(
                                      text: "На завтра рейсов не найдено",
                                    ),
                                  )
                                : ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: temp.length,
                                      itemBuilder:
                                          (BuildContext context, int id) {
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(top: 12.0),
                                          child: VkListItem(data: temp[id]),
                                        );
                                      },
                                    ),
                                  )
                            : const Center(
                                child: Spinner(),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    String url =
        'https://play.google.com/store/apps/developer?id=Artem+Oslopov';
    if (!await launchUrlString(url)) throw 'Could not launch $url';
  }

  Widget getSeporator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 8,
      child: Center(
        child: Container(
          height: 0.5,
          color: (Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF363738)
                  : const Color(0xFFD7D8D9))
              .withOpacity(0.12),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
