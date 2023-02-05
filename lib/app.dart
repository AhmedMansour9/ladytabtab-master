import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ladytabtab/src/constants/theme.dart';

import 'exports_main.dart';
import 'src/constants/routes/route_paths.dart';
import 'src/lang_bloc/applanguage_bloc.dart';

class MyApp extends StatelessWidget {
  static const route = 'myApp';
  const MyApp({
    Key? key,
    this.email,
  }) : super(key: key);
  final String? email;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLangBloc, AppLangState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title:
              state.appLocal == const Locale('en') ? 'LadyTabtab' : "ليدي طبطب",

          // home: BlocConsumer<AuthBloc, AuthState>(
          //   builder: (context, state) {
          //     debugPrint("I am state: $state end");
          //     if (state is AuthStateLoggedIn) {
          //       return const MainScreen();
          //     } else if (state is AuthStateLoggedOut) {
          //       return const LoginScreen();
          //     } else {
          //       return const LoginScreen();
          //     }
          //   },
          //   listener: (context, appState) {
          //     debugPrint('$appState - listener: ${appState.isLoading}');
          //     if (appState.isLoading) {
          //       LoadingProgress.instance()
          //           .show(context: context, message: "message");
          //     } else {
          //       LoadingProgress.instance().hide();
          //     }
          //   },
          // ),

          // home: email == null ? const LoginScreen() : const SplashScreen(),
          home:MainScreen(),
          onGenerateRoute: AppRoutes.generateRoutes,
          localizationsDelegates: const [
            AppLocaleLangs.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          localeResolutionCallback: (currentLocale, supportedLocales) {
            if (currentLocale != null) {
              for (Locale locale in supportedLocales) {
                if (currentLocale.languageCode == locale.languageCode) {
                  return currentLocale;
                }
              }
            }

            return supportedLocales.first;
          },
          locale: state.appLocal,
          themeMode: ThemeMode.light,
          theme: LadyTabtabTheme.lightTheme,
        );
      },
    );
  }
}

class NoSplashFactory extends InteractiveInkFeature {
  NoSplashFactory(
    this._targetRadius,
    this._clipCallback, {
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder,
        _textDirection = textDirection,
        super(
          controller: controller,
          referenceBox: referenceBox,
          color: color,
          onRemoved: onRemoved,
        ) {
    _fadeInController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: controller.vsync,
    )
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _fadeIn = _fadeInController.drive(
      IntTween(
        begin: 0,
        end: color.alpha,
      ),
    );

    _radiusController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: controller.vsync,
    )
      ..addListener(controller.markNeedsPaint)
      ..forward();

    _radius = _radiusController.drive(
      Tween<double>(
        begin: _targetRadius * 0.30,
        end: _targetRadius + 2.0,
      ).chain(_easeCurveTween),
    );

    _fadeOutController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: controller.vsync,
    )
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _fadeOut = _fadeOutController.drive(
      IntTween(
        begin: color.alpha,
        end: 0,
      ).chain(_fadeOutIntervalTween),
    );

    controller.addInkFeature(this);
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final ShapeBorder? _customBorder;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final TextDirection _textDirection;

  late Animation<double> _radius;
  late AnimationController _radiusController;

  late Animation<int> _fadeIn;
  late AnimationController _fadeInController;

  late Animation<int> _fadeOut;
  late AnimationController _fadeOutController;

  static const InteractiveInkFeatureFactory splashFactory = _InkRippleFactory();

  static final Animatable<double> _easeCurveTween =
      CurveTween(curve: Curves.ease);
  static final Animatable<double> _fadeOutIntervalTween =
      CurveTween(curve: const Interval(20.0, 1.0));

  @override
  void confirm() {
    _radiusController
      ..duration = const Duration(milliseconds: 500)
      ..forward();

    _fadeInController.forward();
    _fadeOutController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void cancel() {
    _fadeInController.stop();

    final double fadeOutValue = 1.0 - _fadeInController.value;
    _fadeOutController.value = fadeOutValue;
    if (fadeOutValue < 1.0) {
      _fadeOutController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      dispose();
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final int alpha =
        _fadeInController.isAnimating ? _fadeIn.value : _fadeOut.value;
    final Paint paint = Paint()..color = color.withAlpha(alpha);

    final Offset center = Offset.lerp(
      _position,
      referenceBox.size.center(Offset.zero),
      Curves.ease.transform(_radiusController.value),
    )!;
    paintInkCircle(
      canvas: canvas,
      transform: transform,
      paint: paint,
      center: center,
      textDirection: _textDirection,
      radius: _radius.value,
      customBorder: _customBorder,
      borderRadius: _borderRadius,
      clipCallback: _clipCallback,
    );
  }
}

class _InkRippleFactory extends InteractiveInkFeatureFactory {
  const _InkRippleFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return InkRipple(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}
