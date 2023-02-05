// Internationalization
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocaleLangs {
  // Field
  Locale locale;

  // Constractor
  AppLocaleLangs(this.locale);

  // get locale
  static AppLocaleLangs ofs(BuildContext context) {
    return Localizations.of(context, AppLocaleLangs);
  }

  // Load data
  late Map<String, dynamic> _translatedMap;

  // Load data from path
  Future loadLangs() async {
    String files =
        await rootBundle.loadString("assets/i18n/${locale.languageCode}.json");

    Map<String, dynamic> loadedData = jsonDecode(files);

    _translatedMap = loadedData.map(
      (key, value) => MapEntry(
        key,
        value.toString(),
      ),
    );

    return _translatedMap;
  }

  String getTranslatedData(String key) {
    return _translatedMap[key];
  }

  static const LocalizationsDelegate<AppLocaleLangs> delegate =
      _CustomAppLocalDelegate();
  // End
}

class _CustomAppLocalDelegate extends LocalizationsDelegate<AppLocaleLangs> {
  const _CustomAppLocalDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["en", "ar"].contains(locale.languageCode);
  }

  @override
  Future<AppLocaleLangs> load(Locale locale) async {
    AppLocaleLangs appLocaleInternational = AppLocaleLangs(locale);

    await appLocaleInternational.loadLangs();

    // Load got data as delegate
    return appLocaleInternational;
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<AppLocaleLangs> old,
  ) =>
      false;
}
