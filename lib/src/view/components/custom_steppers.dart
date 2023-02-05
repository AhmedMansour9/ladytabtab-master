import 'package:flutter/material.dart';

Color selectedColor = const Color(0xff4cc940);
Color unSelectedColor = const Color(0xffDDDDDD);

class CustomSteppers extends StatefulWidget {
  final List<StepperModel>? list;
  final int pageIndex;

  const CustomSteppers({
    Key? key,
    this.list,
    required this.pageIndex,
  }) : super(key: key);

  @override
  CustomSteppersState createState() => CustomSteppersState();
}

class CustomSteppersState extends State<CustomSteppers> {
  List<StepperModel>? _list = [];

  @override
  void initState() {
    _list = widget.list;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomSteppers oldWidget) {
    _changeStepper(widget.pageIndex);
    super.didUpdateWidget(oldWidget);
  }

  _changeStepper(int page) {
    for (int index = 0; index < _list!.length; index++) {
      setState(() {
        if (index == page && _list![index].check == false) {
          _list![index].focus = true;
          _list![index].check = true;
        } else if (index == page && _list![index + 1].check == true) {
          _list![index].focus = true;
          _list![index + 1].focus = false;
          _list![index + 1].check = false;
        } else {
          _list![index].focus = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(widget.list!.length, (int index) {
        if (index == 0) {
          return Expanded(
            flex: 1,
            child: FirstStepper(
              model: widget.list![index],
              nextModel: widget.list![index + 1],
              count: widget.list!.length,
            ),
          );
        }
        if (index == widget.list!.length - 1) {
          return Expanded(
            flex: 1,
            child: LastStepper(
              model: widget.list![index],
              count: widget.list!.length,
            ),
          );
        }
        return Expanded(
          flex: 1,
          child: MidStepper(
            model: widget.list![index],
            nextModel: widget.list![index + 1],
            count: widget.list!.length,
          ),
        );
      }),
    );
  }
}

class FirstStepper extends StatelessWidget {
  final StepperModel? model;
  final StepperModel? nextModel;
  final int? count;

  const FirstStepper({Key? key, this.model, this.nextModel, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonWidget(model: model);
  }
}

class LastStepper extends StatelessWidget {
  final StepperModel? model;
  final int? count;

  const LastStepper({Key? key, this.model, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonWidget(model: model);
  }
}

class MidStepper extends StatelessWidget {
  final StepperModel? model;
  final StepperModel? nextModel;
  final int? count;

  const MidStepper({Key? key, required this.model, this.nextModel, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonWidget(model: model);
  }
}

class CommonWidget extends StatelessWidget {
  final StepperModel? model;
  final double radius = 900;

  const CommonWidget({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double size = constraints.maxHeight * 0.4;
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(size * 0.20),
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: model!.focus == true ? selectedColor : unSelectedColor,
                  width: model!.focus == true ? 1.5 : 1,
                ),
              ),
              child: model!.check == true
                  ? Container(
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                    )
                  : Container(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                model!.title!,
                style: TextStyle(
                  color: model!.check == true
                      ? Colors.black
                      : const Color(0xff9a9a9a),
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                maxLines: 1,
              ),
            )
          ],
        );
      },
    );
  }
}

class StepperModel {
  String? title;
  bool check;
  bool focus;
  Color backColor;

  StepperModel({
    this.title,
    this.check = false,
    this.focus = false,
    this.backColor = const Color(0xffececec),
  });
}
