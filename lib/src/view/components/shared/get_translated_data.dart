import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../app_locale_langs.dart';

String getTranslatedData(BuildContext context, String key) {
  return AppLocaleLangs.ofs(context).getTranslatedData(key);
}

String formats(Timestamp timeStamp) {
  DateTime myDate =
      DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  return intl.DateFormat('yyy/MM/dd').format(myDate);
}
