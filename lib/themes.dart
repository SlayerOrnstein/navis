import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const theme = AppTheme._();

  static const _primaryColor = Color(0xE51A5090);
  static const _accentColor = Color(0xFF00BC8C);

  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        splashColor: _accentColor,
      );

  ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        cardColor: const Color(0xFF2C2C2C),
        dialogBackgroundColor: const Color(0xFF212121),
        scaffoldBackgroundColor: const Color(0xFF212121),
        canvasColor: const Color(0xFF212121),
      );

  // TODO(Orn): add amoled theme don't really like it but I must
  ThemeData get amoled => ThemeData();
}