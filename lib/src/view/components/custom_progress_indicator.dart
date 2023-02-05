import 'package:flutter/material.dart';
import 'package:ladytabtab/src/view/theme/palette.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    Key? key,
    this.color = Palette.primaryColor,
    this.strokeWidth = 3.5,
  }) : super(key: key);
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 30.0,
        height: 30.0,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color,
            ),
          ),
        ),
      ),
    );
  }
}
