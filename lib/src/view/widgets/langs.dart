// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../constants/routes/routes.dart';
// import '../../lang_bloc/applanguage_bloc.dart';

// class SelectLanguageScreen extends StatefulWidget {
//   const SelectLanguageScreen({Key? key}) : super(key: key);

//   @override
//   State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
// }

// class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
//   bool selectArabic = false;
//   bool selectEnglish = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Choose language",
//               style: Theme.of(context).textTheme.headline6,
//             ),

//             const SizedBox(height: 50),

//             // English
//             SizedBox(
//               width: 200,
//               child: TextButton(
//                 onPressed: () {
//                   setState(() {
//                     selectEnglish = true;
//                     selectArabic = false;
//                   });
//                 },
//                 child: const Text(
//                   "English",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//                 style: TextButton.styleFrom(
//                   // backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   side: BorderSide(
//                     width: selectEnglish ? 1.3 : 1.0,
//                     color: selectEnglish ? Colors.black : Colors.blueGrey,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 14),

//             // Arabic
//             SizedBox(
//               width: 200,
//               child: TextButton(
//                 onPressed: () {
//                   setState(() {
//                     selectArabic = true;
//                     selectEnglish = false;
//                   });
//                 },
//                 child: const Text(
//                   "العربية",
//                   style: TextStyle(
//                     fontFamily: "Janna",
//                     color: Colors.black54,
//                   ),
//                 ),
//                 style: TextButton.styleFrom(
//                   // backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   side: BorderSide(
//                     width: selectArabic ? 1.3 : 1.0,
//                     color: selectArabic ? Colors.black : Colors.blueGrey,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 75),

//             // Select a language
//             SizedBox(
//               width: 200,
//               // height: 35,
//               child: TextButton(
//                 onPressed: () async {
//                   var prefs = await SharedPreferences.getInstance();
//                   prefs.clear();
//                   setState(() {
//                     if (selectEnglish == true) {
//                       BlocProvider.of<AppLangBloc>(context).add(
//                         AppLangEvent(appLocal: const Locale("en")),
//                       );
//                       prefs.setString("langs", "en");
//                       Navigator.pushNamed(context, Routes.onBoardingScreens);
//                     } else if (selectArabic == true) {
//                       BlocProvider.of<AppLangBloc>(context).add(
//                         AppLangEvent(appLocal: const Locale("ar")),
//                       );
//                       prefs.setString("langs", "ar");
//                       Navigator.pushNamed(context, Routes.onBoardingScreens);
//                     } else {
//                       prefs.clear();
//                       Fluttertoast.cancel();
//                       Fluttertoast.showToast(msg: "Please, select a language.");
//                     }
//                   });
//                 },
//                 child: Text(
//                   "Done",
//                   style: Theme.of(context).textTheme.subtitle1!.copyWith(
//                         color: Colors.white,
//                       ),
//                 ),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   // side: const BorderSide(
//                   //   width: 1.7,
//                   //   color: Colors.pink,
//                   // ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
