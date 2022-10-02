import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class VkListItem extends StatelessWidget {
  final Map data;

  const VkListItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).cardTheme.color!,
          boxShadow: [
            BoxShadow(
              blurRadius: 24.0,
              offset: const Offset(0.0, 2.0),
              color: Theme.of(context).cardTheme.shadowColor!,
            ),
            BoxShadow(
              blurRadius: 2.0,
              offset: const Offset(0.0, 2.0),
              color: Theme.of(context).cardTheme.shadowColor!,
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data["name"],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(height: 8.0),
          Container(
            height: 0.5,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.15)
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          Container(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/articles.svg",
                height: 18,
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorLight,
              ),
              const SizedBox(
                width: 4.0,
              ),
              const Text(
                "Компания:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(width: 8.0),
              Expanded(
                child: Text(
                  data["company"],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: math.pi / 8 * 3,
                    child: Icon(
                      Icons.airplanemode_on,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColorLight,
                    ),
                  ),
                  Container(
                    height: 1.5,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColorLight,
                    width: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 4.0,
              ),
              const Text(
                "Вылет:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(width: 8.0),
              Expanded(
                child: Text(
                  data["departure"],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: math.pi / 8 * 5,
                    child: Icon(
                      Icons.airplanemode_on,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColorLight,
                    ),
                  ),
                  Container(
                    height: 1.5,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColorLight,
                    width: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 4.0,
              ),
              const Text(
                "Прилёт:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(width: 8.0),
              Expanded(
                child: Text(
                  data["arrival"],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.help_outline,
                size: 18,
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorLight,
              ),
              const SizedBox(
                width: 4.0,
              ),
              const Text(
                "Статус:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(width: 8.0),
              Expanded(
                child: Text(
                  data["status"],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
