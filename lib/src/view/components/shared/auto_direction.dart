import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AutoDirection extends StatefulWidget {
  final String text;
  final Widget child;
  final void Function(bool isRTL)? onDirectionChange;

  const AutoDirection({
    Key? key,
    required this.text,
    required this.child,
    this.onDirectionChange,
  }) : super(key: key);

  @override
  AutoDirectionState createState() => AutoDirectionState();
}

class AutoDirectionState extends State<AutoDirection> {
  late String text;
  late Widget childWidget;

  // @override
  // void didUpdateWidget(AutoDirection oldWidget) {
  //   if (isRTL(oldWidget.text) != isRTL(widget.text)) {
  //     WidgetsBinding.instance!.addPostFrameCallback((_) {
  //       widget.onDirectionChange!(isRTL(widget.text));
  //     });
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    text = widget.text;
    childWidget = widget.child;
    return Directionality(
      textDirection:
          isRTL(text) == true ? TextDirection.rtl : TextDirection.ltr,
      child: childWidget,
    );
  }

  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }
}
