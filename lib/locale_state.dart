

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerOfLocale = StateProvider((ref) => SupportedLocales.enUS);

mixin SupportedLocales {
  static const enUS = Locale('en', 'US');
  static const es = Locale('es');

  static final all = [enUS, es];

  // handles defaulting to english, and matching country if specified in both
  static Locale getSupportedLocale(Locale locale) {
    final countryCode = locale.countryCode;
    final langCode = locale.languageCode;
    return SupportedLocales.all.firstWhere((loc) {
      if (loc.countryCode != null && countryCode != null) {
        return loc.languageCode == langCode && loc.countryCode == countryCode;
      }
      return loc.languageCode == langCode;
    }, orElse: () => SupportedLocales.enUS);
  }
}

Locale? getSupportedLanguageByCode(String? code) {
  if (code == null) {
    return null;
  }

  List<String> langCountrySplit;
  if (code.contains('-')) {
    langCountrySplit = code.split('-');
  } else if (code.contains('_')) {
    langCountrySplit = code.split('_');
  } else {
    langCountrySplit = [code];
  }
  final langCode = langCountrySplit.first;
  final countryCode = langCountrySplit.last;

  return SupportedLocales.all.firstWhere(
    (loc) =>
        loc.languageCode == langCode &&
        (loc.countryCode == null || loc.countryCode == countryCode),
        orElse: () => SupportedLocales.enUS
  );
}

String getLanguageByString(String language) {
  switch (language) {
    case 'en-US':
      return 'English';
    case 'es':
      return 'Español';
    default:
      return 'English';
  }
}