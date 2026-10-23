import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';

/// VKUI `Input`. Styling comes from the theme's `inputDecorationTheme`.
class VkInput extends StatelessWidget {
  const VkInput({
    super.key,
    required this.controller,
    this.placeholder,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.obscureText = false,
    this.autocorrect = true,
    this.error = false,
    this.after,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
  });

  final TextEditingController controller;
  final String? placeholder;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool autocorrect;
  final bool error;
  final Widget? after;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final theme = Theme.of(context).inputDecorationTheme;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      autocorrect: autocorrect,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      cursorRadius: const Radius.circular(2),
      style: VkTypography.text.copyWith(color: vk.textPrimary),
      decoration: InputDecoration(
        hintText: placeholder,
        suffixIcon: after,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        fillColor: error ? vk.backgroundNegativeTint : null,
        enabledBorder: error ? theme.errorBorder : null,
      ),
    );
  }
}

/// Read-only field that opens a picker, like VKUI `CustomSelect`/`DateInput`.
class VkSelectField extends StatelessWidget {
  const VkSelectField({
    super.key,
    required this.value,
    required this.onTap,
    this.placeholder,
    this.icon,
  });

  final String? value;
  final String? placeholder;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final empty = value == null || value!.isEmpty;
    return Material(
      color: vk.fieldBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: vk.fieldBorderAlpha, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  empty ? placeholder ?? '' : value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: VkTypography.text.copyWith(
                    color: empty ? vk.textSecondary : vk.textPrimary,
                    fontFeatures: VkTypography.tabular,
                  ),
                ),
              ),
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    icon ?? Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: vk.iconSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
