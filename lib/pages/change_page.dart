import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tiksi_avia/components/list_change_item.dart';
import 'package:tiksi_avia/components/spinner.dart';
import 'package:tiksi_avia/components/text.dart';
import 'package:tiksi_avia/pages/settings_page.dart';

import 'change_page_2.dart';

class ChangePage extends StatefulWidget {
  const ChangePage({Key? key}) : super(key: key);

  @override
  ChangePageState createState() => ChangePageState();
}

class ChangePageState extends State<ChangePage> {
  DateTime selectedDate = DateTime.now();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Box data = Hive.box('data');

  bool delAvaible = true;

  @override
  void initState() {
    databaseReference =
        FirebaseDatabase.instance.ref().child(dateFormat(selectedDate));
    databaseReference.onValue.listen(
      (event) {
        data.put('change', event.snapshot.value ?? [0]);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dateFormat(selectedDate)),
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
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => changeDate(),
                icon: SvgPicture.asset(
                  "assets/calendar_icon.svg",
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                  height: 28,
                  width: 28,
                ),
                iconSize: 28,
                splashRadius: 20,
              );
            },
          ),
          Container(width: 4),
        ],
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFEBEDF0)
            : const Color(0xFF0A0A0A),
        child: ValueListenableBuilder(
          valueListenable: data.listenable(),
          builder: (BuildContext context, Box<dynamic> box, Widget? widget) {
            List list = List.from(
              box.get('change', defaultValue: []),
            );
            return list.isNotEmpty
                ? list[0] == 0
                    ? Center(
                        child: SecondaryText(
                          text: "На ${getDate(selectedDate)} рейсов не найдено",
                          fontSize: 16,
                        ),
                      )
                    : ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView.builder(
                          itemCount: list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int id) {
                            return Container(
                              margin: const EdgeInsets.only(top: 12.0),
                              child: VkListChangeItem(
                                data: list[id],
                                delTap: () => del(id),
                                penTap: () => change(id, list[id]),
                                delActive: delAvaible,
                              ),
                            );
                          },
                        ),
                      )
                : const Center(
                    child: Spinner(),
                  );
          },
        ),
      ),
    );
  }

  String getDate(DateTime currentDate) {
    return "${currentDate.day.toString()}.${currentDate.month.toString()}.${currentDate.year.toString()}";
  }

  void del(int id) async {
    setState(() {
      delAvaible = false;
    });
    DatabaseReference temp =
        FirebaseDatabase.instance.ref().child(dateFormat(selectedDate));
    ConnectivityResult internet = await Connectivity().checkConnectivity();
    if (internet == ConnectivityResult.mobile ||
        internet == ConnectivityResult.wifi) {
      try {
        List<Map<dynamic, dynamic>> list1 =
            List.from((await temp.get()).value as List);
        List<Map<dynamic, dynamic>> list2 = [];
        for (int i = 0; i < list1.length; i++) {
          if (i != id) {
            list2.add(list1[i]);
          }
        }
        for (int i = 0; i < list2.length; i++) {
          Map<dynamic, dynamic> data = list2[i];
          list2.setAll(i, {data});
        }
        temp.set(list2);
        showSnackBar(
          context: context,
          text: "Рейс успешно удалён",
          icon: SvgPicture.asset(
            "assets/icon_done.svg",
            color: const Color(0xFF4BB34B),
          ),
        );
      } catch (e) {
        showSnackBar(
          text: "Неизвестная ошибка",
          icon: SvgPicture.asset(
            "assets/icon_cancel.svg",
            color: const Color(0xFFE64646),
          ),
          context: context,
        );
      }
    } else {
      showSnackBar(
        text: "Нет подключения к интернету",
        icon: SvgPicture.asset(
          "assets/icon_globe_cross_outline.svg",
          color: const Color(0xFFE64646),
        ),
        context: context,
      );
    }
    setState(() {
      delAvaible = true;
    });
  }

  void change(int id, Map<dynamic, dynamic> data) {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (BuildContext context) =>
            ChangePage2(data: data, id: id, date: selectedDate)));
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

  String dateFormat(DateTime temp) {
    return "${temp.day.toString()}-${temp.month.toString()}-${temp.year.toString()}";
  }

  void changeDate() async {
    DateTime? temp = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      currentDate: DateTime.now(),
      firstDate: DateTime(2021, 11, 30),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      helpText: "Дата",
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              primaryColorDark: Colors.blue,
              accentColor: Colors.blueAccent,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );
    if (temp != null && temp != selectedDate) {
      data.put('change', []);
      setState(
        () {
          selectedDate = temp;
          databaseReference =
              FirebaseDatabase.instance.ref().child(dateFormat(selectedDate));
          databaseReference.onValue.listen((event) {
            data.put('change', event.snapshot.value ?? [0]);
          });
        },
      );
    }
  }
}
