import '../../exports_main.dart';

class LadyTabtabTheme {
  static get currentLang => AppLanguage().appLocal;

  static ThemeData get lightTheme {
    return ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Color.fromARGB(45, 248, 101, 38),
        cursorColor: Palette.primaryColor,
        selectionHandleColor: Palette.primaryColor,
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 14),
        ),
        indicatorColor: const Color.fromARGB(255, 255, 231, 220),
      ),
      highlightColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      tooltipTheme: const TooltipThemeData(
        triggerMode: TooltipTriggerMode.manual,
        decoration: BoxDecoration(
          color: Palette.secondaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(Palette.primaryColor),
      ),
      brightness: Brightness.light,
      scaffoldBackgroundColor: Palette.mainBackgroundColor,
      fontFamily: currentLang == const Locale('ar') ? "Janna" : "Montserrat",
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          maximumSize: MaterialStateProperty.all(const Size(500, 42)),
          minimumSize: MaterialStateProperty.all(const Size(5, 40)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(4),
          ),
          elevation: MaterialStateProperty.all(0.5),
          shadowColor: MaterialStateProperty.all(Palette.elevationColor),
          overlayColor: MaterialStateProperty.all(Colors.black12),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return Palette.primaryColor;
          }),
          // textStyle: MaterialStateProperty.all(
          // Theme.of(context).textTheme.subtitle2!.copyWith(
          //       color: Palette.bgColor,
          //       fontFamily: currentLang == const Locale('ar')
          //           ? "Janna"
          //           : "Montserrat",
          //     ),
          // ),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: Radiuz.largeRadius,
            ),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.fromLTRB(12, 7, 12, 0),
        filled: true,
        fillColor: Palette.whiteColor,
        border: InputBorder.none,
        // hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
        //       fontFamily: "Janna",
        //       color: Colors.grey.shade400,
        //     ),
        enabledBorder: kOutlineInputBorderActive,
        focusedBorder: kOutlineInputBorderActive,
        errorBorder: kOutlineInputBorderActive,
        disabledBorder: kOutlineInputBorderActive,
        focusedErrorBorder: kOutlineInputBorderActive,
      ),
      textTheme: TextTheme(
        subtitle1: TextStyle(
          fontFamily:
              currentLang == const Locale('ar') ? "Janna" : "Montserrat",
          height: 1.5,
        ),
        subtitle2: TextStyle(
          fontFamily:
              currentLang == const Locale('ar') ? "Janna" : "Montserrat",
          height: 1.5,
        ),
        headline6: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily:
              currentLang == const Locale('ar') ? "Janna" : "Montserrat",
          height: 1.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Palette.whiteColor,
        shadowColor: Palette.elevationColor,
        elevation: 7.0,
        titleTextStyle: TextStyle(
          // fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
          fontFamily:
              currentLang == const Locale('ar') ? "Janna" : "Montserrat",
        ),
        // titleTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
        //       color: Colors.black,
        //       fontFamily: currentLang == const Locale('ar')
        //           ? "Janna"
        //           : "Montserrat",
        //     ),
      ),
      tabBarTheme: const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        unselectedLabelColor: Color.fromARGB(255, 169, 169, 169),
        labelColor: Color.fromARGB(255, 169, 169, 169),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Color.fromARGB(255, 226, 226, 226),
        ),
      ),
    );
  }
}

// ThemeData ladytabtabTheme(
//   AppLanguage value,
//   BuildContext context,
//   IconThemeData iconThemeData,
// ) {
//   ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
//     style: ButtonStyle(
//       maximumSize: MaterialStateProperty.all(const Size(500, 42)),
//       minimumSize: MaterialStateProperty.all(const Size(5, 40)),
//       padding: MaterialStateProperty.all(
//         const EdgeInsets.all(4),
//       ),
//       elevation: MaterialStateProperty.all(0.5),
//       shadowColor: MaterialStateProperty.all(Palette.elevationColor),
//       overlayColor: MaterialStateProperty.all(Colors.black12),
//       backgroundColor: MaterialStateProperty.resolveWith((states) {
//         return Palette.primaryColor;
//       }),
//       textStyle: MaterialStateProperty.all(
//         Theme.of(context).textTheme.subtitle2!.copyWith(
//               color: Palette.bgColor,
//               fontFamily: currentLang == const Locale('ar')
//                   ? "Janna"
//                   : "Montserrat",
//             ),
//       ),
//       shape: MaterialStateProperty.all(
//         const RoundedRectangleBorder(
//           borderRadius: Radiuz.largeRadius,
//         ),
//       ),
//     ),
//   );

//   InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
//     contentPadding: const EdgeInsets.fromLTRB(12, 7, 12, 0),
//     filled: true,
//     fillColor: Palette.whiteColor,
//     border: InputBorder.none,
//     hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
//           fontFamily: "Janna",
//           color: Colors.grey.shade400,
//         ),
//     enabledBorder: kOutlineInputBorderActive,
//     focusedBorder: kOutlineInputBorderActive,
//     errorBorder: kOutlineInputBorderActive,
//     disabledBorder: kOutlineInputBorderActive,
//     focusedErrorBorder: kOutlineInputBorderActive,
//   );

//   TextTheme _textTheme = TextTheme(
//     subtitle1: TextStyle(
//       fontFamily:
//           currentLang == const Locale('ar') ? "Janna" : "Montserrat",
//       height: 1.5,
//     ),
//     subtitle2: TextStyle(
//       fontFamily:
//           currentLang == const Locale('ar') ? "Janna" : "Montserrat",
//       height: 1.5,
//     ),
//     headline6: TextStyle(
//       fontWeight: FontWeight.normal,
//       fontFamily:
//           currentLang == const Locale('ar') ? "Janna" : "Montserrat",
//       height: 1.5,
//     ),
//   );

//   AppBarTheme _appBarTheme = AppBarTheme(
//     iconTheme: iconThemeData,
//     actionsIconTheme: iconThemeData,
//     backgroundColor: Palette.whiteColor,
//     shadowColor: Palette.elevationColor,
//     elevation: 7.0,
//     titleTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
//           color: Colors.black,
//           fontFamily:
//               currentLang == const Locale('ar') ? "Janna" : "Montserrat",
//         ),
//   );

//   TabBarTheme _tabBarTheme = const TabBarTheme(
//     indicatorSize: TabBarIndicatorSize.tab,
//     labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     unselectedLabelColor: Color.fromARGB(255, 169, 169, 169),
//     labelColor: Color.fromARGB(255, 169, 169, 169),
//     indicator: BoxDecoration(
//       borderRadius: BorderRadius.all(
//         Radius.circular(10),
//       ),
//       color: Color.fromARGB(255, 226, 226, 226),
//     ),
//   );

//   TooltipThemeData _tooltipThemeData = const TooltipThemeData(
//     triggerMode: TooltipTriggerMode.longPress,
//     decoration: BoxDecoration(
//       color: Palette.secondaryColor,
//       borderRadius: BorderRadius.all(
//         Radius.circular(10),
//       ),
//     ),
//   );

//   // RETURN ME
//   return ThemeData(
//     highlightColor: Colors.transparent,
//     splashFactory: InkRipple.splashFactory,
//     tooltipTheme: _tooltipThemeData,
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: Palette.mainColor,
//     fontFamily: currentLang == const Locale('ar') ? "Janna" : "Montserrat",
//     elevatedButtonTheme: _elevatedButtonThemeData,
//     inputDecorationTheme: _inputDecorationTheme,
//     textTheme: _textTheme,
//     appBarTheme: _appBarTheme,
//     tabBarTheme: _tabBarTheme,
//   );
// }
