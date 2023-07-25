import 'dart:ui';

import 'package:flutter/material.dart';

/// (S)pacing
///
/// Suitable for margin and padding constants.
class S {
  S._();

  static const half = x1 / 2;
  static const x1 = 5.0;
  static const x2 = x1 * 2;
  static const x3 = x1 * 3;
  static const x4 = x1 * 4;
  static const x5 = x1 * 5;
  static const x6 = x1 * 6;
  static const x7 = x1 * 7;

  static double x(double multiplier) => x1 * multiplier;
}

/// (R)adius
///
/// Suitable for border radius constants.
class R {
  R._();

  static const x1 = 5.0;
  static const x2 = x1 * 2;
  static const x3 = x1 * 3;
  static const x4 = x1 * 4;
  static const x5 = x1 * 5;

  static double x(double multiplier) => x1 * multiplier;
}

/// (C)olor
///
/// Suitable for color constants.
class C {
  C._();

  /// This is the first color of the brand gradient.
  static const GENIUS_PRIMARY = Color(0xFF1A67FB);

  static const GENIUS_PRIMARY_LIGHT = Color(0xFF6A9BFA);

  static const GENIUS_WHITE = Color(0xFFFFFFFF);

  static const GENIUS_BLACK = Color(0xFF000000);

  static const GENIUS_GREY_LIGHT = Color(0xFFF8FBFB);

  static const GENIUS_GREY = Color.fromARGB(255, 217, 222, 222);

  static const GENIUS_GREY_DARK = Color(0xFF989797);

  /// This is the last color of the brand gradient.
  static const GENIUS_PURPLE = Color(0xFF7230FC);

  /// The full brand gradient.
  ///
  /// ..not the actual gradient though! The Figma isn't as purple as the Genius purple,
  /// so I've fudged some of the values to make it look more like the Figma designs.
  static final GENIUS_PRIMARY_GRADIENT = LinearGradient(
    colors: [
      GENIUS_PRIMARY,
      GENIUS_PRIMARY,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final GENIUS_PRIMARY_LIGHT_GRADIENT = LinearGradient(
    colors: [
      GENIUS_PRIMARY_LIGHT,
      GENIUS_PRIMARY_LIGHT,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final GENIUS_ACCENT_GRADIENT = LinearGradient(
    colors: [
      Color(0xFF17F212),
      Color(0xFF04C100),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static final GENIUS_ERROR_GRADIENT = LinearGradient(
    colors: [
      Color.fromARGB(255, 242, 193, 18),
      Color.fromARGB(255, 243, 166, 13),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static final GENIUS_BLACK_GRADIENT = LinearGradient(
    colors: [
      GENIUS_BLACK,
      GENIUS_BLACK,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static final GENIUS_WHITE_GRADIENT = LinearGradient(
    colors: [
      GENIUS_WHITE,
      GENIUS_WHITE,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Common color for all background shadows.
  static const BACKGROUND_SHADOW = Color(0x660B0B0B);
}

extension LinearGradientExtension on LinearGradient {
  LinearGradient withOpacity({double opacityStart = 1, double? opacityEnd}) {
    List<Color> newColors = [...colors];

    newColors[0] = newColors[0].withOpacity(opacityStart);
    if (opacityEnd != null && newColors.length > 1) {
      final lastIndex = newColors.length - 1;
      newColors[lastIndex] = newColors[lastIndex].withOpacity(opacityEnd);
    }

    return LinearGradient(
      colors: newColors,
      begin: begin,
      end: end,
    );
  }
}

/// (F)ilter
///
/// Suitable for filter constants.
class F {
  F._();

  static final BACKGROUND_BLUR = ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0);
}

/// Box shadow for cards.
final SHADOW_CARD = BoxShadow(
  color: Colors.black26,
  offset: Offset(0, 4),
  blurRadius: 4,
);
