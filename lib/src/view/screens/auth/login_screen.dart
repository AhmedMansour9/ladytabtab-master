import 'package:flutter/cupertino.dart';

import '../../../constants/routes/routes.dart';
import '../../../view_models/services/shared_prefs_services.dart';
import '../../components/or_line.dart';
import '../../components/social_buttons.dart';
import '../../widgets/custom_progress_dialog.dart';
import '../home/export.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  static const String route = '/loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = true;
  bool isObscureText = true;
  late SharedPrefsServices sharedPrefsServices;
  late TextEditingController emailController, passwordController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    sharedPrefsServices = SharedPrefsServices();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  final AuthServices _authServices = AuthServices();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      // backgroundColor: Palette.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 14),
                  const CustomLogo(size: 55),
                  const SizedBox(height: 22),
                  Text(
                    getTranslatedData(context, "welcomeBack"),
                    style: Theme.of(context).textTheme.headline5,
                    // style: const TextStyle(
                    //   fontSize: 25,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                  const SizedBox(height: 27),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslatedData(context, "notMember"),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Palette.greyColor,
                            ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterScreen.route);
                        },
                        child: Text(
                          getTranslatedData(context, "joinNow"),
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: Palette.primaryColor,
                                  ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  // Or
                  const SocialButtons(),

                  const SizedBox(height: 20),
                  const OrLine(),

                  // Form
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.84,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 22),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              } else {
                                return getTranslatedData(context, "required");
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xFF626262),
                              ),
                              hintText: getTranslatedData(context, "email"),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: passwordController,
                            obscureText: isObscureText,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              } else {
                                return getTranslatedData(context, "required");
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF626262),
                              ),
                              suffixIcon: Material(
                                color: Colors.transparent,
                                elevation: 0.0,
                                shadowColor: Colors.transparent,
                                child: IconButton(
                                  icon: Icon(
                                    isObscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF626262),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isObscureText = !isObscureText;
                                    });
                                  },
                                ),
                              ),
                              hintText: getTranslatedData(context, "password"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            CupertinoSwitch(
                              value: rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  rememberMe = val;
                                });
                              },
                              activeColor: Palette.primaryColor,
                              // trackColor: Colors.green,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              getTranslatedData(context, "rememberMe"),
                              style: const TextStyle(
                                color: Palette.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        // const Spacer(),
                        // Text(
                        //   getTranslatedData(context, "forgot"),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (rememberMe == true) {
                        sharedPrefsServices.setStringData(
                          'login',
                          emailController.text,
                        );
                      }
                      buildCustomShowDialog(context);
                      _authServices
                          .logInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      )
                          .then((value) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesPaths.mainScreens,
                          (route) => false,
                        );
                      }).catchError((error) {
                        if (error.message ==
                            "A network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
                          var snackBar = const SnackBar(
                            content: Text(
                              'Please check the interenet connection!',
                            ),
                            backgroundColor: Color.fromARGB(255, 242, 227, 227),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        } else {
                          var snackBar = SnackBar(
                            content: Text(error.message.toString()),
                            backgroundColor: Palette.errorColor,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: Text(
                    getTranslatedData(context, "logIn"),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Palette.whiteColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesPaths.mainScreens,
                      (route) => false,
                    );
                  },
                  child: Text(
                    "تصفحي منتجاتنا",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Palette.secondaryColor,
                        ),
                  ),
                ),
              ),

              // End page
            ],
          ),
        ),
      ),
    );
  }
}
