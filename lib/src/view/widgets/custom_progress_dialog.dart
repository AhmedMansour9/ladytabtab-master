import 'package:flutter/material.dart';

import '../components/custom_progress_indicator.dart';

Future buildCustomShowDialog(BuildContext ctx, {Color? color}) {
  return showDialog(
    barrierDismissible: false,
    useRootNavigator: false,
    context: ctx,
    builder: (context) {
      return Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: const CustomProgressIndicator(),
        ),
      );
    },
  );
}
