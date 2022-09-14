import 'package:flutter/material.dart';

class SecondaryText extends StatelessWidget {
  const SecondaryText({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.w400,
  }) : super(key: key);

  final String text;
  final int fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFF8b8c8b)
            : const Color(0xFF767876),
        fontWeight: FontWeight.w400,
        fontSize: fontSize.toDouble(),
      ),
      textAlign: textAlign,
    );
  }
}
