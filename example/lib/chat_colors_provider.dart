import 'package:flutter/material.dart';

class ChatColorsProvider extends ChangeNotifier {
  String _themePrimaryColor = '5B9BD5';
  String _themeSecondaryColor = '70AD47';  
  String _themeTertiaryColor = 'FFC000';

  String get themePrimaryColor => _themePrimaryColor;
  String get themeSecondaryColor => _themeSecondaryColor;
  String get themeTertiaryColor => _themeTertiaryColor;

  void updateThemeColors({
    String? primaryColor,
    String? secondaryColor,
    String? tertiaryColor,
  }) {
    bool hasChanged = false;
    
    if (primaryColor != null && primaryColor != _themePrimaryColor) {
      _themePrimaryColor = primaryColor;
      hasChanged = true;
    }
    
    if (secondaryColor != null && secondaryColor != _themeSecondaryColor) {
      _themeSecondaryColor = secondaryColor;
      hasChanged = true;
    }
    
    if (tertiaryColor != null && tertiaryColor != _themeTertiaryColor) {
      _themeTertiaryColor = tertiaryColor;
      hasChanged = true;
    }
    
    if (hasChanged) {
      notifyListeners();
    }
  }

  Color? parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;
    
    try {
      String cleanColor = colorString.replaceAll('#', '');
      if (cleanColor.isEmpty) return null;
      if (cleanColor.length == 6) cleanColor = 'FF$cleanColor';
      if (cleanColor.length == 8) {
        return Color(int.parse(cleanColor, radix: 16));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Color get primaryColor => parseColor(_themePrimaryColor) ?? const Color(0xFF5B9BD5);
  Color get secondaryColor => parseColor(_themeSecondaryColor) ?? const Color(0xFF70AD47);
  Color get tertiaryColor => parseColor(_themeTertiaryColor) ?? const Color(0xFFFFC000);

  ThemeData createTheme(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        brightness: brightness,
      ),
      useMaterial3: true,
      brightness: brightness,
    );
  }
}