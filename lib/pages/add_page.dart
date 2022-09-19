import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tiksi_avia/components/button.dart';
import 'package:tiksi_avia/components/form.dart';
import 'package:tiksi_avia/components/input.dart';
import 'package:tiksi_avia/pages/fb.dart';
import 'package:tiksi_avia/pages/settings_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  Fb fb = Fb();

  bool awaitSend = false;

  DateTime selectedDate = DateTime.now();
  TimeOfDay departureTime = const TimeOfDay(hour: 12, minute: 00);
  TimeOfDay arrivalTime = const TimeOfDay(hour: 12, minute: 30);

  TextEditingController _dateController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  TextEditingController _departureController =
      TextEditingController(text: '12:00');
  TextEditingController _arrivalController =
      TextEditingController(text: '12:30');
  final TextEditingController _statusController = TextEditingController();
  static List<String> flights = [
    "Тикси - Борогон",
    "Борогон - Тикси",
    "Тикси - Хара-Улах",
    "Хара-Улах - Тикси",
    "Тикси - Булун",
    "Булун - Тикси",
    "Тикси - Таймылыр",
    "Таймылыр - Тикси",
    "Тикси - Сиктях",
    "Сиктях - Тикси",
    "Тикси - Якутск",
    "Якутск - Тикси",
    "Тикси - Кюсюр",
    "Кюсюр - Тикси",
    "Тикси - Москва",
    "Москва - Тикси",
    "Тикси - Булун-Сиктях",
    "Тикси - Борогон-Хара-Улах",
  ];

  String date = '';
  String name = flights[0];
  String company = '';
  String departure = '12:00';
  String arrival = '12:30';
  String status = '';

  bool buttonAvaible = false;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: dateFormat(selectedDate));
    _companyController
        .addListener(() => setState(() => company = _companyController.text));
    _statusController
        .addListener(() => setState(() => status = _statusController.text));
  }

  @override
  void dispose() {
    _companyController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buttonAvaible = check();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Добавление рейса"),
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
                            onTap: () {
                              changeDate();
                            },
                            suffixIcon: Icon(
                              Icons.more_horiz,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle!
                                  .color,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: FormItem(
                          title: "Имя рейса",
                          child: DropdownButtonFormField<String>(
                            value: name,
                            items: flights.map<DropdownMenuItem<String>>(
                              (String val) {
                                Text temp = Text(val.toString());
                                return DropdownMenuItem(
                                  value: val,
                                  child: temp,
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  name = val ?? "";
                                },
                              );
                            },
                            style: TextStyle(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle!
                                  .color,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(12.0),
                              fillColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color(0xFFf2F3F5)
                                  : const Color(0xFF2C2D2E),
                              filled: true,
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColorLight,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black.withOpacity(0.12)
                                      : Colors.white.withOpacity(0.12),
                                  width: 0.5,
                                ),
                              ),
                            ),
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
                            suffixIcon: Icon(
                              Icons.more_horiz,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle!
                                  .color,
                            ),
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
                            suffixIcon: Icon(
                              Icons.more_horiz,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle!
                                  .color,
                            ),
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
                          text: "Добавить рейс",
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

    await fb.sendData(
      {
        'arrival': arrival,
        'company': company,
        'departure': departure,
        'name': name,
        'status': status,
      },
      date,
    ).then(
      (value) {
        setState(() {
          awaitSend = false;
        });
        switch (value) {
          case 'ok':
            showSnackBar(
              context: context,
              text: "Рейс успешно добавлен",
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
      String time = "${temp.hour.toString()} :";
      String minute = temp.minute.toString().length == 1
          ? "0 ${temp.minute.toString()}"
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
    if (temp != null) {
      String date = dateFormat(temp);
      setState(() {
        selectedDate = temp;
        this.date = date;
        _dateController = TextEditingController(text: this.date);
      });
    }
  }

  String dateFormat(DateTime temp) {
    return date =
        "${temp.day.toString()}-${temp.month.toString()}-${temp.year.toString()}";
  }

  bool check() {
    if (date == '' ||
        name == '' ||
        company == '' ||
        departure == '' ||
        arrival == '' ||
        status == '') {
      return false;
    } else {
      return true;
    }
  }
}
