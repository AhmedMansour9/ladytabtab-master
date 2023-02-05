import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:ladytabtab/exports_main.dart';
import 'package:ladytabtab/src/constants/routes/routes.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';

import '../widgets/custom_progress_dialog.dart';

// class SocialButtons extends StatelessWidget {
//   const SocialButtons({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         GestureDetector(
//           onTap: () async {},
//           child: Container(
//             width: 50,
//             height: 50,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Color.fromARGB(255, 126, 226, 154),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: SvgPicture.asset(kFacebookIcon),
//             ),
//           ),
//         ),

//         // const SizedBox(width: 30),

//         // TODO: TEST GOOGLE SIGN IN
//         GestureDetector(
//           onTap: () {
//             debugPrint("Presseeed");
//             context.read<AuthBloc>().add(
//                   const AuthEventLogIn(
//                     email: "testapp@gmail.com",
//                     password: "1234567",
//                   ),
//                 );
//           },
//           child: Container(
//             width: 50,
//             height: 50,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Color.fromARGB(255, 201, 219, 238),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: SvgPicture.asset(kGoogleIcon),
//             ),
//           ),
//         ),

//         // const SizedBox(width: 30),
//         GestureDetector(
//           onTap: () {},
//           child: Container(
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(255, 234, 247, 248),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: ClipOval(
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                   ),
//                   child: Image.asset(
//                     kAppleLogo,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

/// ======================================================== ///

class SocialButtons extends StatefulWidget {
  const SocialButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  late SharedPrefsServices sharedPrefsServices;

  @override
  void initState() {
    super.initState();
    sharedPrefsServices = SharedPrefsServices();
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () async {
            buildCustomShowDialog(context);
            await _authServices
                .signInWithFacebook()
                .then((userCredential) async {
              print("Facebook auth: $userCredential end");
              if (userCredential != null) {
                _authServices.addUserData(
                  uid: userCredential.user!.uid,
                  fullName: userCredential.user!.displayName,
                  email: userCredential.user!.email ??
                      userCredential.user!.phoneNumber,
                  password: null,
                  mobileNo: userCredential.user!.phoneNumber,
                );

                sharedPrefsServices.setStringData(
                  'login',
                  userCredential.user!.email,
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesPaths.mainScreens,
                  (route) => false,
                );
              } else if (userCredential == null) {
                Navigator.pop(context);
                var snackBar = const SnackBar(
                  content: Text("لا يمكنك تسجيل الدخول في الوقت الحالي"),
                  backgroundColor: Palette.errorColor,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (userCredential.user!.email == null) {
                // TODO: DELETE USER FROM AUTH
                _authServices.deleteUser();
                // _authServices.logOutFacebook();

                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(getTranslatedData(context, "emailRequired")),
                      content: Text(getTranslatedData(context, "noEmailFound")),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _authServices.logOut();

                            // Navigator.pop(context);
                          },
                          child: Text(getTranslatedData(context, "close")),
                        )
                      ],
                    );
                  },
                );
              }
            }).catchError((error) {});
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.secondaryColor.withOpacity(0.05),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(kFacebookIcon),
            ),
          ),
        ),

        // const SizedBox(width: 30),

        // TODO: TEST GOOGLE SIGN IN
        GestureDetector(
          onTap: () async {
            buildCustomShowDialog(context);
            _authServices.signInWithGoogle().then((value) {
              _authServices.addUserData(
                uid: value.user!.uid,
                fullName: value.user!.displayName,
                email: value.user!.email ?? '',
                password: '',
                mobileNo: value.user!.phoneNumber,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesPaths.mainScreens,
                (route) => false,
              );
              sharedPrefsServices.setStringData('login', value.user!.email);
            }).catchError((error) {
              Navigator.pop(context);
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.secondaryColor.withOpacity(0.05),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(kGoogleIcon),
            ),
          ),
        ),

        // const SizedBox(width: 30),
        GestureDetector(
          onTap: () async {
            buildCustomShowDialog(context);

            _authServices.signInWithApple().then((value) {
              _authServices.addUserData(
                uid: value.user!.uid,
                fullName: value.user!.displayName,
                email: value.user!.email ?? '',
                password: '',
                mobileNo: value.user!.phoneNumber,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesPaths.mainScreens,
                (route) => false,
              );
              sharedPrefsServices.setStringData('login', value.user!.email);
            }).catchError((error) {
              Navigator.pop(context);
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 234, 247, 248),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: ClipOval(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    kAppleLogo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
