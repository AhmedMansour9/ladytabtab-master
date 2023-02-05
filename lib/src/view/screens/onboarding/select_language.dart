import 'package:flutter/material.dart';

class SelectWidget extends StatelessWidget {
  const SelectWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final String title;

  final bool isSelected;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF3F3F3),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(),
        ),
      ),
    );
  }
}
