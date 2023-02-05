import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/palette.dart';
import 'shared/constants.dart';

class CustomArrowBack extends StatelessWidget {
  const CustomArrowBack({
    Key? key,
    required this.ctx,
  }) : super(key: key);
  final BuildContext? ctx;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (ctx != null) {
          ScaffoldMessenger.of(ctx!).clearSnackBars();
        }
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        primary: Palette.greyColor,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: size,
        maximumSize: size,
      ),
      child: const Icon(
        CupertinoIcons.back,
        color: Colors.black,
        // size: 24,
      ),
    );
  }
}
