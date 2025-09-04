import 'package:flutter/material.dart';
import 'app_localizations.dart';

class LocalizationHelper {
  static Locale parseLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'pt-br':
      case 'pt_br':
        return const Locale('pt', 'BR');
      case 'pt-pt':
      case 'pt_pt':
      case 'pt':
        return const Locale('pt', 'PT');
      case 'en-us':
      case 'en_us':
      case 'en':
        return const Locale('en', 'US');
      case 'es-es':
      case 'es_es':
      case 'es':
        return const Locale('es', 'ES');
      default:
        return const Locale('pt', 'BR'); // Default fallback
    }
  }

  static AppLocalizations getLocalizations(String language) {
    final locale = parseLanguage(language);
    return AppLocalizations(locale);
  }

  static bool isSupported(String language) {
    final locale = parseLanguage(language);
    return AppLocalizations.supportedLocales.contains(locale) ||
        ['pt', 'en', 'es'].contains(locale.languageCode);
  }
}