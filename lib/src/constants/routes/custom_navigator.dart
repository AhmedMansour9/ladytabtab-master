import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ladytabtab/src/lang_bloc/applanguage_bloc.dart';

class CustomRouteBuilder extends PageRouteBuilder {
  final Widget child;
  CustomRouteBuilder({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) {
            return child;
          },
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    var checkLang = BlocProvider.of<AppLangBloc>(context).state;
    var begin = checkLang.appLocal == const Locale('ar')
        ? const Offset(-1.0, 0.0)
        : const Offset(1.0, 0.0);
    var end = Offset.zero;
    // var curve = Curves.easeInOut;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );
    var curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );
    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}
