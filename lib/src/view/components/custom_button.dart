// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     Key? key,
//     required this.onTap,
//     this.isSelected = false,
//     required this.title,
//     this.color = Colors.white,
//     this.fontColor = Colors.black,
//   }) : super(key: key);

//   final void Function() onTap;
//   final bool isSelected;
//   final String title;
//   final Color color;
//   final Color fontColor;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialButton(
//       onPressed: onTap,
//       child: Text(
//         title,
//         style: TextStyle(
//           color: fontColor,
//           fontSize: 18,
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 50),
//       color: color,
//       elevation: 1.3,
//       highlightElevation: 0.0,
//       minWidth: MediaQuery.of(context).size.width * 0.80,
//       height: 45,
//       shape: RoundedRectangleBorder(
//         side: isSelected
//             ? const BorderSide(
//                 color: Colors.green,
//                 width: 1.3,
//               )
//             : BorderSide.none,
//         borderRadius: BorderRadius.circular(7.0),
//       ),
//     );
//   }
// }
