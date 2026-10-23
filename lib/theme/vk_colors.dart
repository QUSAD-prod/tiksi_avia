import 'package:flutter/material.dart';

/// VKUI color tokens (themes `vkIOS` / `vkIOSDark` from `@vkontakte/vkui-tokens`).
///
/// Widgets read them with `context.vk` instead of branching on brightness.
@immutable
class VkColors extends ThemeExtension<VkColors> {
  const VkColors({
    required this.background,
    required this.backgroundContent,
    required this.backgroundSecondary,
    required this.backgroundSecondaryAlpha,
    required this.backgroundModal,
    required this.backgroundAccent,
    required this.backgroundAccentThemed,
    required this.backgroundAccentThemedAlpha,
    required this.backgroundInfoTint,
    required this.backgroundPositiveTint,
    required this.backgroundNegativeTint,
    required this.backgroundWarning,
    required this.backgroundSnackbar,
    required this.backgroundSegment,
    required this.textPrimary,
    required this.textSecondary,
    required this.textSubhead,
    required this.textTertiary,
    required this.textAccent,
    required this.textAccentThemed,
    required this.textContrastThemed,
    required this.textPositive,
    required this.textNegative,
    required this.textWarning,
    required this.iconAccent,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.separatorPrimary,
    required this.separatorPrimaryAlpha,
    required this.fieldBackground,
    required this.fieldBorderAlpha,
    required this.highlight,
    required this.shadow,
  });

  final Color background;
  final Color backgroundContent;
  final Color backgroundSecondary;
  final Color backgroundSecondaryAlpha;
  final Color backgroundModal;
  final Color backgroundAccent;
  final Color backgroundAccentThemed;
  final Color backgroundAccentThemedAlpha;
  final Color backgroundInfoTint;
  final Color backgroundPositiveTint;
  final Color backgroundNegativeTint;
  final Color backgroundWarning;
  final Color backgroundSnackbar;
  final Color backgroundSegment;
  final Color textPrimary;
  final Color textSecondary;
  final Color textSubhead;
  final Color textTertiary;
  final Color textAccent;
  final Color textAccentThemed;
  final Color textContrastThemed;
  final Color textPositive;
  final Color textNegative;
  final Color textWarning;
  final Color iconAccent;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color separatorPrimary;
  final Color separatorPrimaryAlpha;
  final Color fieldBackground;
  final Color fieldBorderAlpha;

  /// Pressed state of tappable rows (`colorTransparent` active state).
  final Color highlight;
  final Color shadow;

  static const light = VkColors(
    background: Color(0xFFEBEDF0),
    backgroundContent: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFF5F5F5),
    backgroundSecondaryAlpha: Color(0x0A000000),
    backgroundModal: Color(0xFFFFFFFF),
    backgroundAccent: Color(0xFF2688EB),
    backgroundAccentThemed: Color(0xFF2688EB),
    backgroundAccentThemedAlpha: Color(0x332688EB),
    backgroundInfoTint: Color(0xFFDEEEFF),
    backgroundPositiveTint: Color(0xFFE8F9E8),
    backgroundNegativeTint: Color(0xFFFFE9E9),
    backgroundWarning: Color(0xFFFFF2D6),
    backgroundSnackbar: Color(0xFFFFFFFF),
    backgroundSegment: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF818C99),
    textSubhead: Color(0xFF6D7885),
    textTertiary: Color(0xFF99A2AD),
    textAccent: Color(0xFF2688EB),
    textAccentThemed: Color(0xFF2688EB),
    textContrastThemed: Color(0xFFFFFFFF),
    textPositive: Color(0xFF4BB34B),
    textNegative: Color(0xFFE64646),
    // VKUI has no warning text token; this is colorIconWarning darkened for contrast.
    textWarning: Color(0xFFC77700),
    iconAccent: Color(0xFF2688EB),
    iconSecondary: Color(0xFF99A2AD),
    iconTertiary: Color(0xFFB8C1CC),
    separatorPrimary: Color(0xFFD7D8D9),
    separatorPrimaryAlpha: Color(0x1F000000),
    fieldBackground: Color(0xFFF2F3F5),
    fieldBorderAlpha: Color(0x1F000000),
    highlight: Color(0x1400103D),
    shadow: Color(0x14000000),
  );

  static const dark = VkColors(
    background: Color(0xFF0A0A0A),
    backgroundContent: Color(0xFF19191A),
    backgroundSecondary: Color(0xFF232324),
    backgroundSecondaryAlpha: Color(0x1AFFFFFF),
    backgroundModal: Color(0xFF1C1D1E),
    backgroundAccent: Color(0xFF529EF4),
    backgroundAccentThemed: Color(0xFFFFFFFF),
    backgroundAccentThemedAlpha: Color(0x33FFFFFF),
    backgroundInfoTint: Color(0xFF1C3954),
    backgroundPositiveTint: Color(0xFF2E3E2B),
    backgroundNegativeTint: Color(0xFF522E2E),
    backgroundWarning: Color(0xFF473315),
    backgroundSnackbar: Color(0xFF2C2D2E),
    backgroundSegment: Color(0xFF626364),
    textPrimary: Color(0xFFE1E3E6),
    textSecondary: Color(0xFF76787A),
    textSubhead: Color(0xFF969A9F),
    textTertiary: Color(0xFF5D5F61),
    textAccent: Color(0xFF529EF4),
    textAccentThemed: Color(0xFFFFFFFF),
    textContrastThemed: Color(0xFF000000),
    textPositive: Color(0xFF4BB34B),
    textNegative: Color(0xFFFF5C5C),
    textWarning: Color(0xFFEDB055),
    iconAccent: Color(0xFF529EF4),
    iconSecondary: Color(0xFF76787A),
    iconTertiary: Color(0xFF5D5F61),
    separatorPrimary: Color(0xFF363738),
    separatorPrimaryAlpha: Color(0x1FFFFFFF),
    fieldBackground: Color(0xFF232324),
    fieldBorderAlpha: Color(0x1FFFFFFF),
    highlight: Color(0x14FFFFFF),
    shadow: Color(0x00000000),
  );

  @override
  VkColors copyWith() => this;

  @override
  VkColors lerp(VkColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return VkColors(
      background: l(background, other.background),
      backgroundContent: l(backgroundContent, other.backgroundContent),
      backgroundSecondary: l(backgroundSecondary, other.backgroundSecondary),
      backgroundSecondaryAlpha: l(
        backgroundSecondaryAlpha,
        other.backgroundSecondaryAlpha,
      ),
      backgroundModal: l(backgroundModal, other.backgroundModal),
      backgroundAccent: l(backgroundAccent, other.backgroundAccent),
      backgroundAccentThemed: l(
        backgroundAccentThemed,
        other.backgroundAccentThemed,
      ),
      backgroundAccentThemedAlpha: l(
        backgroundAccentThemedAlpha,
        other.backgroundAccentThemedAlpha,
      ),
      backgroundInfoTint: l(backgroundInfoTint, other.backgroundInfoTint),
      backgroundPositiveTint: l(
        backgroundPositiveTint,
        other.backgroundPositiveTint,
      ),
      backgroundNegativeTint: l(
        backgroundNegativeTint,
        other.backgroundNegativeTint,
      ),
      backgroundWarning: l(backgroundWarning, other.backgroundWarning),
      backgroundSnackbar: l(backgroundSnackbar, other.backgroundSnackbar),
      backgroundSegment: l(backgroundSegment, other.backgroundSegment),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textSubhead: l(textSubhead, other.textSubhead),
      textTertiary: l(textTertiary, other.textTertiary),
      textAccent: l(textAccent, other.textAccent),
      textAccentThemed: l(textAccentThemed, other.textAccentThemed),
      textContrastThemed: l(textContrastThemed, other.textContrastThemed),
      textPositive: l(textPositive, other.textPositive),
      textNegative: l(textNegative, other.textNegative),
      textWarning: l(textWarning, other.textWarning),
      iconAccent: l(iconAccent, other.iconAccent),
      iconSecondary: l(iconSecondary, other.iconSecondary),
      iconTertiary: l(iconTertiary, other.iconTertiary),
      separatorPrimary: l(separatorPrimary, other.separatorPrimary),
      separatorPrimaryAlpha: l(
        separatorPrimaryAlpha,
        other.separatorPrimaryAlpha,
      ),
      fieldBackground: l(fieldBackground, other.fieldBackground),
      fieldBorderAlpha: l(fieldBorderAlpha, other.fieldBorderAlpha),
      highlight: l(highlight, other.highlight),
      shadow: l(shadow, other.shadow),
    );
  }
}

extension VkColorsContext on BuildContext {
  VkColors get vk => Theme.of(this).extension<VkColors>()!;

  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
}
