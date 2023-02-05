import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarTheme {
  static var transparentStatusBar = SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  static var portraitUpOnly = SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
}
