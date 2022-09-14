import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:tiksi_avia/components/text.dart';

class FormItem extends StatelessWidget {
  const FormItem({
    Key? key,
    required this.title,
    required this.child,
    this.error = "",
  }) : super(key: key);

  final String title;
  final Widget child;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: SecondaryText(
            text: title,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: error == "" ? 0.0 : 8.0),
          child: child,
        ),
        error == ""
            ? Container()
            : Text(
                error,
                style: const TextStyle(
                  color: Color(0xFFE64646),
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
                textAlign: TextAlign.left,
              ),
      ],
    );
  }
}
