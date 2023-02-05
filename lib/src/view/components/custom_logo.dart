import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/shared/constants.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({
    this.size = 70,
    this.color = Colors.black12,
    Key? key,
  }) : super(key: key);

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      kLogoIcon,
      width: size,
      color: color,
    );
  }
}
