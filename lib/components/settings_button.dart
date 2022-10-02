import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiksi_avia/components/text.dart';

enum SettingsButtonMode { selectBt, switchBt }

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
    required this.text,
    this.description,
    this.onClickSelect,
    this.onClickSwitch,
    required this.value,
    this.icon,
    this.settingsButtonMode = SettingsButtonMode.switchBt,
  }) : super(key: key);

  final Widget? icon;
  final String text;
  final String? description;
  final void Function(bool)? onClickSwitch;
  final void Function()? onClickSelect;
  final SettingsButtonMode settingsButtonMode;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: settingsButtonMode == SettingsButtonMode.switchBt
            ? () {
                onClickSwitch != null ? onClickSwitch!.call(!value) : null;
              }
            : onClickSelect,
        highlightColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFEBEBEB)
            : const Color(0xFF2B2B2B),
        splashFactory: InkRipple.splashFactory,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              Container(
                height: 24,
                width: icon == null ? 0 : 24,
                margin: icon == null ? null : const EdgeInsets.only(right: 10),
                child: icon,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    description == null || description == ''
                        ? Container()
                        : SecondaryText(text: description!),
                  ],
                ),
              ),
              Container(width: 16),
              settingsButtonMode == SettingsButtonMode.switchBt
                  ? Switch(
                      value: value,
                      onChanged: onClickSwitch,
                      activeColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorLight,
                    )
                  : SizedBox(
                      width: 59,
                      height: 21,
                      child: Center(
                        child: value
                            ? SvgPicture.asset(
                                'assets/icon_done.svg',
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorLight,
                              )
                            : null,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
