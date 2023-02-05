import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.color,
  }) : super(key: key);
  final Widget child;
  final void Function() onPressed;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: color,
      elevation: 0.0,
      highlightElevation: 0.0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
