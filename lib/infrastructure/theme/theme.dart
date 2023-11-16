import 'package:flutter/material.dart';
import 'package:graphics/graphics_consts/graphics_color_consts.dart';

class AppThemes {
  static ThemeData light() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: GraphicsColorConsts.lilyWhite,
      primaryColor: GraphicsColorConsts.purple,
      appBarTheme: const AppBarTheme(
        backgroundColor: GraphicsColorConsts.purple,
      ),
    );
  }
}
