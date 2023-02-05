import 'dart:math';
import 'package:flutter/cupertino.dart';

import '../../../../exports_main.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  List<String> imgs = const [
    'assets/images/onboarding/onBoarding.jpeg',
  ];
  PageController pageController = PageController();
  // double _percentage = 0.25;
  int indexer = 0;
  late AppLanguage appLanguage;

  Color borderColor = Colors.grey.shade100;
  final Color _color = Colors.white;

  Future<void> getCurrentLang() async {
    await appLanguage.fetchLocale();
  }

  @override
  void initState() {
    super.initState();
    appLanguage = AppLanguage();
    getCurrentLang();
    // getPercentage(0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentLang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF9BD25),
      backgroundColor: Palette.primaryColor,
      // appBar: AppBar(
      //   title: const CustomLogo(size: 50),
      // ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              // flex: 3,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (currentIndex) {
                    setState(() {
                      indexer = currentIndex;
                    });
                    // getPercentage(currentIndex);
                  },
                  itemCount: imgs.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // const SizedBox(height: 20),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              height: 110,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "خيرات الطبيعة بين يديك الآن! 💐",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      fontFamily: "Janna",
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 20),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircleAvatar(
                                radius: 200,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                  imgs[index],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 90,
              child: GestureDetector(
                onTap: () {
                  pageController.nextPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                  // getPercentage(indexer);
                  // if (indexer == 3) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.route,
                    (route) => false,
                  );
                  // }
                },
                child: CustomPaint(
                  painter: CustomStroke(
                    percentage: 1.0,
                    color: _color,
                    borderColor: borderColor,
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _color,
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.chevron_left,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class CustomStroke extends CustomPainter {
  final double percentage;
  final Color color;
  final Color borderColor;

  CustomStroke({
    required this.percentage,
    required this.color,
    required this.borderColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = min(25, size.height);
    final Offset center = Offset(size.width / 2, size.height / 2);
    Paint defaultCirclePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint progressCirclePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, defaultCirclePaint);

    double arcAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      progressCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
