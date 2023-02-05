import 'package:flutter/material.dart';

import '../custom_arrow_back.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.ctx,
    this.isCenter = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final BuildContext? ctx;
  final bool? isCenter;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      leading: CustomArrowBack(ctx: context),
      centerTitle: isCenter,
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(60);
  }
}
