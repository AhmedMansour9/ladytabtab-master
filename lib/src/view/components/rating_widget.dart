import 'package:flutter/material.dart';

import '../theme/palette.dart';

class RatingBar extends StatelessWidget {
  const RatingBar({
    Key? key,
    required this.rating,
    this.color = Colors.amber,
    this.size = 18.0,
  }) : super(key: key);

  final double rating;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (int index) {
        return Icon(
          () {
            if (index < rating.floor()) {
              return Icons.star;
            } else if (index + 0.5 <= rating) {
              return Icons.star_half;
            } else {
              return Icons.star_border;
            }
          }(),
          color: Palette.primaryColor,
          size: size,
        );
      }),
    );
  }
}
