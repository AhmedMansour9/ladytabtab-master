import '../../../../exports_main.dart';
import '../../../constants/routes/routes.dart';
import '../../components/or_line.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';
import '../../components/social_buttons.dart';
import '../../widgets/custom_progress_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String route = '/registerScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController fullNameController,
      emailController,
      passwordController,
      mobileNoController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late AuthServices authServices;

  late SharedPrefsServices sharedPrefsServices;
  bool isObscureText = true;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    mobileNoController = TextEditingController();
    authServices = AuthServices();
    sharedPrefsServices = SharedPrefsServices();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    mobileNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                const SizedBox(height: 14),
                const CustomLogo(size: 55),
                const SizedBox(height: 22),
                Text(
                  getTranslatedData(context, "welcome"),
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 27),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslatedData(context, "alreadyMember"),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Palette.greyColor,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginScreen.route,
                          (route) => false,
                        );
                      },
                      child: Text(
                        getTranslatedData(context, "logIn"),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
                          controller: fullNameController,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              return null;
                            } else {
                              return getTranslatedData(context, "required");
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF626262),
                            ),
                            hintText: getTranslatedData(context, "fullName"),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              return null;
                            } else {
                              return getTranslatedData(context, "required");
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email_outlined,
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
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: mobileNoController,
                          // maxLength: 11,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9]'),
                            ),
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.singleLineFormatter,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return getTranslatedData(context, "required");
                            } else if (!RegExp('^01[0125][0-9]{8}')
                                .hasMatch(value)) {
                              return "رقم هاتف غير صحيح";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const SizedBox(
                              width: 10,
                              height: 30,
                              child: Center(
                                child: Text(
                                  '+20',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            hintText: getTranslatedData(context, "mobile"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: ScreenSize.screenWidth! * 0.84,
                  height: 48,
                  child: ElevatedButton(
                    child: Text(
                      getTranslatedData(context, "register").toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        buildCustomShowDialog(context);
                        authServices
                            .signUpWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        )
                            .then((value) {
                          authServices.addUserData(
                            uid: authServices.auth.currentUser!.uid,
                            // tokenId: ,
                            fullName: fullNameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            mobileNo: mobileNoController.text,
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesPaths.mainScreens,
                            (route) => false,
                          );
                          sharedPrefsServices.setStringData(
                            'login',
                            emailController.text,
                          );
                        }).catchError((error) {
                          Navigator.pop(context);
                          var snackBar = SnackBar(
                            content: Text(
                              error.message.toString(),
                            ),
                            backgroundColor: Palette.errorColor,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    },
                  ),
                ),

                // End
              ],
            ),
          ),
        ),
      ),
    );
  }
}
