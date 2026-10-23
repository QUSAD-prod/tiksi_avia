import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'vk_colors.dart';
import 'vk_typography.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final vk = brightness == Brightness.light ? VkColors.light : VkColors.dark;
  final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: vk.backgroundAccent,
    onPrimary: Colors.white,
    secondary: vk.backgroundAccent,
    onSecondary: Colors.white,
    error: vk.textNegative,
    onError: Colors.white,
    surface: vk.backgroundContent,
    onSurface: vk.textPrimary,
    onSurfaceVariant: vk.textSecondary,
    surfaceContainerHighest: vk.fieldBackground,
    surfaceContainerHigh: vk.backgroundModal,
    surfaceContainer: vk.backgroundModal,
    outline: vk.fieldBorderAlpha,
    outlineVariant: vk.separatorPrimaryAlpha,
    surfaceTint: Colors.transparent,
  );

  final fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: vk.fieldBorderAlpha, width: 0.5),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    extensions: [vk],
    scaffoldBackgroundColor: vk.backgroundContent,
    canvasColor: vk.backgroundContent,
    dividerColor: vk.separatorPrimaryAlpha,
    // VKUI on iOS highlights pressed rows instead of drawing ripples.
    splashFactory: isIOS ? NoSplash.splashFactory : InkRipple.splashFactory,
    splashColor: vk.highlight,
    highlightColor: vk.highlight,
    hoverColor: vk.highlight,
    textTheme: Typography.material2021(platform: defaultTargetPlatform)
        .englishLike
        .apply(bodyColor: vk.textPrimary, displayColor: vk.textPrimary),
    iconTheme: IconThemeData(color: vk.iconAccent),
    appBarTheme: AppBarTheme(
      backgroundColor: vk.backgroundContent,
      foregroundColor: vk.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 52,
      titleSpacing: isIOS ? 0 : 4,
      iconTheme: IconThemeData(color: vk.iconAccent),
      actionsIconTheme: IconThemeData(color: vk.iconAccent),
      titleTextStyle: (isIOS ? VkTypography.title3 : VkTypography.title2)
          .copyWith(color: vk.textPrimary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: vk.backgroundAccent,
      selectionColor: vk.backgroundAccent.withValues(alpha: 0.24),
      selectionHandleColor: vk.backgroundAccent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: vk.fieldBackground,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      hintStyle: VkTypography.text.copyWith(color: vk.textSecondary),
      border: fieldBorder,
      enabledBorder: fieldBorder,
      disabledBorder: fieldBorder,
      focusedBorder: fieldBorder.copyWith(
        borderSide: BorderSide(color: vk.backgroundAccent, width: 1),
      ),
      errorBorder: fieldBorder.copyWith(
        borderSide: BorderSide(color: vk.textNegative, width: 1),
      ),
      focusedErrorBorder: fieldBorder.copyWith(
        borderSide: BorderSide(color: vk.textNegative, width: 1),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? vk.backgroundAccent : null,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: vk.backgroundSnackbar,
      contentTextStyle: VkTypography.paragraph.copyWith(color: vk.textPrimary),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: vk.backgroundModal,
      modalBackgroundColor: vk.backgroundModal,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: vk.iconTertiary,
      dragHandleSize: const Size(36, 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: vk.backgroundModal,
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: vk.backgroundContent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: vk.backgroundModal,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: vk.backgroundModal,
      headerForegroundColor: vk.textPrimary,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: vk.backgroundModal,
      dialBackgroundColor: vk.fieldBackground,
      hourMinuteColor: vk.fieldBackground,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: vk.backgroundAccent,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: vk.textPrimary,
      unselectedLabelColor: vk.textSecondary,
      labelStyle: VkTypography.headline2,
      unselectedLabelStyle: VkTypography.headline2,
      dividerColor: vk.separatorPrimaryAlpha,
      dividerHeight: 0.5,
      overlayColor: WidgetStatePropertyAll(vk.highlight),
      splashFactory: NoSplash.splashFactory,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: vk.backgroundAccent, width: 2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
  );
}
