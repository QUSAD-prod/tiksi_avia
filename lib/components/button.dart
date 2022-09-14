import 'package:flutter/material.dart';

enum ButtonMode { primary, outlined, text }

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.text,
    required this.onClick,
    this.icon,
    this.mode = ButtonMode.primary,
    this.active = true,
    this.textButtonColor,
  }) : super(key: key);

  final String text;
  final Function() onClick;
  final ButtonMode mode;
  final Widget? icon;
  final bool active;
  final Color? textButtonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: getBorder(context),
        color: getBackground(context),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: active ? () => onClick() : null,
          borderRadius: BorderRadius.circular(8.0),
          highlightColor: getHightlight(context),
          child: getChild(context),
        ),
      ),
    );
  }

  Color? getHightlight(BuildContext context) {
    switch (mode) {
      case ButtonMode.primary:
        return Theme.of(context).brightness == Brightness.light
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.2);
      case ButtonMode.outlined:
      case ButtonMode.text:
        return null;
    }
  }

  Color getBackground(BuildContext context) {
    switch (mode) {
      case ButtonMode.primary:
        return Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor.withOpacity(active ? 1.0 : 0.4)
            : const Color(0xFFE1E2E1).withOpacity(active ? 1.0 : 0.4);
      case ButtonMode.outlined:
        return Colors.transparent;
      case ButtonMode.text:
        return Colors.transparent;
    }
  }

  Border? getBorder(BuildContext context) {
    switch (mode) {
      case ButtonMode.primary:
        return null;
      case ButtonMode.outlined:
        return Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).primaryColor.withOpacity(active ? 1.0 : 0.4)
              : const Color(0xFFE1E2E1).withOpacity(active ? 1.0 : 0.4),
          width: 1.0,
        );
      case ButtonMode.text:
        return null;
    }
  }

  Color getForegroundColor(BuildContext context) {
    switch (mode) {
      case ButtonMode.primary:
        return Theme.of(context).brightness == Brightness.light
            ? Theme.of(context)
                .primaryTextTheme
                .button!
                .color!
                .withOpacity(active ? 1.0 : 0.4)
            : Theme.of(context).backgroundColor.withOpacity(active ? 1.0 : 0.4);
      case ButtonMode.outlined:
        return Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor.withOpacity(active ? 1.0 : 0.4)
            : const Color(0xFFE1E2E1).withOpacity(active ? 1.0 : 0.4);
      case ButtonMode.text:
        return Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor.withOpacity(active ? 1.0 : 0.4)
            : const Color(0xFFE1E2E1).withOpacity(active ? 1.0 : 0.4);
    }
  }

  Widget getChild(BuildContext context) {
    if (icon != null) {
      return Container(
        margin: mode != ButtonMode.text
            ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)
            : const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 8.0),
                child: Center(child: icon),
              ),
              Text(
                text,
                style: TextStyle(
                  color: textButtonColor ?? getForegroundColor(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: mode != ButtonMode.text
            ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)
            : const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getForegroundColor(context),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
