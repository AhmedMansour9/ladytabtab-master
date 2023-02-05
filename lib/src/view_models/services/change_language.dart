import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = const Locale('ar');
  Locale get appLocal => _appLocale;
  String? myLang = '';
  String? get currentLang => myLang;

  set setLang(var val) {
    _appLocale = val;
  }

  Future<void> fetchLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('langs') == null) {
      _appLocale = const Locale('ar');
    }
    myLang = prefs.getString('langs');
    _appLocale = Locale(myLang ?? 'ar');
    notifyListeners();
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == const Locale("ar")) {
      await prefs.setString('langs', 'ar').then(
            (value) => _appLocale = const Locale("ar"),
          );
    } else if (type == const Locale("en")) {
      await prefs.setString('langs', 'en').then(
            (value) => _appLocale = const Locale("en"),
          );
    }
    notifyListeners();
  }
}
