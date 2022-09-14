import 'package:flutter/material.dart';

class DateChanger extends StatelessWidget {
  final int value;
  final void Function() onTap;
  const DateChanger({Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: getItem(context, "Сегодня", 0)),
          Expanded(child: getItem(context, "Завтра", 1)),
        ],
      ),
    );
  }

  Widget getItem(BuildContext context, String text, int id) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          highlightColor: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFEBEBEB)
              : const Color(0xFF2B2B2B),
          onTap: value != id ? onTap : null,
          child: Container(
            margin:
                const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4.5),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: value == id
                          ? Theme.of(context).appBarTheme.foregroundColor
                          : Theme.of(context)
                              .appBarTheme
                              .foregroundColor!
                              .withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
                ),
                Container(
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: value == id
                        ? Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
