import 'package:flutter/material.dart';

import '../../../app_locale_langs.dart';

class LangText {
  static const String login = "logIn";
  static const String logout = "logout";
}

class MyTranslate {
  const MyTranslate(this.context, this.text);
  final String text;
  final BuildContext context;

  String _translate() {
    return AppLocaleLangs.ofs(context).getTranslatedData(text);
  }

  get translate => _translate();
}
