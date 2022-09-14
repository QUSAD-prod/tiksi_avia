import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    required this.hint,
    required this.controller,
    required this.isPass,
    this.keyboardType = TextInputType.text,
    this.errorEnabled = false,
    this.errorText,
    this.maxLenght,
    this.autocorrect = true,
    this.onEditingComplete,
    this.onChanged,
    this.onTap,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmit,
    this.focusNode,
    this.autofillHints,
    this.labelText,
    this.readOnly = false,
  }) : super(key: key);

  final String hint;
  final TextEditingController controller;
  final bool isPass;
  final TextInputType? keyboardType;
  final bool errorEnabled;
  final String? errorText;
  final int? maxLenght;
  final bool autocorrect;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final String? labelText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      autofillHints: autofillHints,
      onEditingComplete: onEditingComplete,
      maxLength: maxLenght,
      keyboardType: keyboardType,
      controller: controller,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onSubmit,
      textInputAction: textInputAction,
      obscureText: isPass,
      autocorrect: autocorrect,
      focusNode: focusNode,
      cursorRadius: const Radius.circular(2),
      onTap: onTap == null ? () => {} : onTap!,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        counterStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        errorText: errorEnabled ? errorText : null,
        contentPadding: const EdgeInsets.all(12.0),
        fillColor: errorEnabled
            ? Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFFAEBEB)
                : const Color(0xFF522E2E)
            : Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFf2F3F5)
                : const Color(0xFF2C2D2E),
        filled: true,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: errorEnabled
                ? const Color(0xFFE64646)
                : Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: errorEnabled
                ? const Color(0xFFE64646)
                : Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.12)
                    : Colors.white.withOpacity(0.12),
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
