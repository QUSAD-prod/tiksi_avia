import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tiksi_avia/components/button.dart';
import 'package:tiksi_avia/components/form.dart';
import 'package:tiksi_avia/components/input.dart';
import 'avia_board_page.dart';
import 'fb.dart';

class ChangePage2 extends StatefulWidget {
  const ChangePage2({
    Key? key,
    required this.data,
    required this.id,
    required this.date,
  }) : super(key: key);

  final Map<dynamic, dynamic> data;
  final int id;
  final DateTime date;

  @override
  ChangePage2State createState() => ChangePage2State();
}

class ChangePage2State extends State<ChangePage2> {
  bool awaitSend = false;

  Fb fb = Fb();

  TimeOfDay departureTime = const TimeOfDay(hour: 12, minute: 00);
  TimeOfDay arrivalTime = const TimeOfDay(hour: 12, minute: 30);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _departureController = TextEditingController();
  TextEditingController _arrivalController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  String date = '';
  String name = '';
  String company = '';
  String departure = '';
  String arrival = '';
  String status = '';

  bool buttonAvaible = false;

  @override
  void initState() {
    super.initState();
    date = dateFormat(widget.date);
    name = widget.data['name'];
    company = widget.data['company'];
    departure = widget.data['departure'];
    arrival = widget.data['arrival'];
    status = widget.data['status'];
    _dateController = TextEditingController(text: dateFormat(widget.date));
    _nameController = TextEditingController(text: name);
    _companyController = TextEditingController(text: company);
    _departureController = TextEditingController(text: departure);
    _arrivalController = TextEditingController(text: arrival);
    _statusController = TextEditingController(text: status);
    departureTime = TimeOfDay(
        hour: int.parse(departure.split(':')[0]),
        minute: int.parse(departure.split(':')[1]));
    arrivalTime = TimeOfDay(
        hour: int.parse(arrival.split(':')[0]),
        minute: int.parse(arrival.split(':')[1]));
    _statusController
        .addListener(() => setState(() => status = _statusController.text));
  }

  @override
  void dispose() {
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buttonAvaible = check();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактирование рейса"),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 0.5,
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFD7D8D9)
                    : const Color(0xFF363738),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: FormItem(
                          title: 'Дата',
                          child: Input(
                            hint: 'Дата',
                            controller: _dateController,
                            isPass: false,
                            readOnly: true,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: FormItem(
                          title: "Имя рейса",
                          child: Input(
                            hint: "Имя рейса",
                            controller: _nameController,
                            isPass: false,
                            readOnly: true,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: FormItem(
                          title: 'Компания',
                          child: Input(
                            hint: 'Компания',
                            controller: _companyController,
                            isPass: false,
                            readOnly: true,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: FormItem(
                          title: 'Вылет',
                          child: Input(
                            hint: 'Вылет',
                            controller: _departureController,
                            isPass: false,
                            readOnly: true,
                            onTap: () {
                              changeTime(0);
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: FormItem(
                          title: 'Прилёт',
                          child: Input(
                            hint: 'Прилёт',
                            controller: _arrivalController,
                            isPass: false,
                            readOnly: true,
                            onTap: () {
                              changeTime(1);
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: FormItem(
                          title: 'Статус',
                          child: Input(
                            hint: 'Статус',
                            controller: _statusController,
                            isPass: false,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Button(
                          active: !awaitSend && buttonAvaible,
                          text: "Сохранить изменения",
                          onClick: () => send(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void send() async {
    setState(() {
      awaitSend = true;
    });
    await fb.updateData(
      {
        'arrival': arrival,
        'company': company,
        'departure': departure,
        'name': name,
        'status': status,
      },
      dateFormat(widget.date),
      widget.id,
    ).then(
      (value) {
        setState(() {
          awaitSend = false;
        });
        switch (value) {
          case 'ok':
            showSnackBar(
              context: context,
              text: "Изменения успешно сохранены",
              icon: SvgPicture.asset(
                "assets/icon_done.svg",
                color: const Color(0xFF4BB34B),
              ),
            );
            Navigator.pop(context);
            break;
          case 'network-request-failed':
            showSnackBar(
              text: "Нет подключения к интернету",
              icon: SvgPicture.asset(
                "assets/icon_globe_cross_outline.svg",
                color: const Color(0xFFE64646),
              ),
              context: context,
            );
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

  void changeTime(int id) async {
    TimeOfDay? temp = await showTimePicker(
      context: context,
      initialTime: id == 0 ? departureTime : arrivalTime,
      cancelText: "Отмена",
      confirmText: "Ок",
      helpText: id == 0 ? "Время вылета" : "Время прилёта",
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            primaryColorDark: Colors.blue,
            accentColor: Colors.blueAccent,
            brightness: Theme.of(context).brightness,
          )),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );
    if (temp != null) {
      String time = "${temp.hour.toString()}:";
      String minute = temp.minute.toString().length == 1
          ? "0${temp.minute.toString()}"
          : temp.minute.toString();
      time += minute;
      setState(
        () {
          id == 0 ? departureTime = temp : arrivalTime = temp;
          id == 0 ? departure = time : arrival = time;
          id == 0
              ? _departureController = TextEditingController(text: departure)
              : _arrivalController = TextEditingController(text: arrival);
        },
      );
    }
  }

  String dateFormat(DateTime temp) {
    return date =
        "${temp.day.toString()}-${temp.month.toString()}-${temp.year.toString()}";
  }

  bool check() {
    if (departure == '' || arrival == '' || status == '') {
      return false;
    } else {
      return true;
    }
  }
}
