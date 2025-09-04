import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  void setThemeMode(String mode) {
    switch (mode) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    
    // Update system UI overlay style based on theme
    final brightness = _themeMode == ThemeMode.dark 
        ? Brightness.dark 
        : (_themeMode == ThemeMode.light ? Brightness.light : null);
    
    if (brightness != null) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: brightness,
          statusBarIconBrightness: brightness == Brightness.dark 
              ? Brightness.light 
              : Brightness.dark,
        ),
      );
    }
    
    notifyListeners();
  }
  
  String get currentThemeMode {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}