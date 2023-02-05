import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ladytabtab/src/constants/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  late Widget result;
  @override
  void initState() {
    super.initState();

    result = const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.orange,
            ),
          ),
        ),
      ),
    );

    timer = Timer(
      const Duration(milliseconds: 2500),
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesPaths.mainScreens,
          (route) => false,
        );
      },
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return result;
  }
}
