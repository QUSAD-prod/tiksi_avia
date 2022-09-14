import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClick,
    this.fontSize = 17,
  }) : super(key: key);

  final Widget icon;
  final String text;
  final void Function() onClick;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        highlightColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFEBEBEB)
            : const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          child: Row(
            children: [
              Container(
                height: 28,
                width: 28,
                margin: const EdgeInsets.only(right: 14),
                child: icon,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
