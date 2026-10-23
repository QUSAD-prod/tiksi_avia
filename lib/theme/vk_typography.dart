import 'package:flutter/painting.dart';

/// VKUI type scale (vkIOS). Colors are applied by the widgets that use them.
abstract final class VkTypography {
  static const title1 = TextStyle(
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w600,
  );
  static const title2 = TextStyle(
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w600,
  );
  static const title3 = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w600,
  );
  static const headline1 = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w500,
  );
  static const headline2 = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w500,
  );
  static const text = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
  );
  static const paragraph = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
  );
  static const subhead = TextStyle(
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w400,
  );
  static const footnote = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w400,
  );

  /// Use with an upper-cased string: Flutter has no text-transform.
  static const footnoteCaps = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  static const caption1 = TextStyle(
    fontSize: 12,
    height: 14 / 12,
    fontWeight: FontWeight.w400,
  );

  /// Monospaced digits keep times in the flight cards aligned.
  static const tabular = [FontFeature.tabularFigures()];
}
