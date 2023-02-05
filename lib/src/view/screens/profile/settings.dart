import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app.dart';

import '../../../../exports_main.dart';
import '../../../lang_bloc/applanguage_bloc.dart';
import '../../../constants/routes/routes.dart';
import '../../../models/collection/app_collections.dart';
import '../../components/shared/custom_app_bar.dart';
import '../../components/shared/get_translated_data.dart';
import '../onboarding/select_language.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  static const route = 'settingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool selected = true;

  final currentUser = FirebaseAuth.instance.currentUser;

  late String contentText;
  SharedPrefsServices sharedPrefsServices = SharedPrefsServices();

  late String fullName = "";

  Future<void> getFullName() async {
    final currentUserUid = currentUser!.uid;
    switch (FirebaseAuth.instance.currentUser!.displayName) {
      case null:
      case "null":
      case '':
        // GET FULLNAME FROM FIRESTORE
        await AppCollections.users.doc(currentUserUid).get().then(
          (value) {
            setState(() {
              fullName = value.get('fullName') ?? "Gest";
            });
          },
        );
        break;

      default:
        fullName = FirebaseAuth.instance.currentUser!.displayName!;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getFullName();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contentText = getTranslatedData(context, "selectLang");
  }

  Future<bool?> buildShowDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          content: Text(
            contentText,
            textAlign: TextAlign.center,
          ),
          actions: [
            SelectWidget(
              title: 'English',
              isSelected: false,
              onPressed: () {
                // Will select english language
                if (BlocProvider.of<AppLangBloc>(context).state.appLocal !=
                    const Locale('en')) {
                  BlocProvider.of<AppLangBloc>(context)
                      .add(AppLangEvent(appLocal: const Locale("en")));

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MyApp(
                          email: FirebaseAuth.instance.currentUser!.email,
                        );
                      },
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pop(true);
                }
              },
            ),
            SelectWidget(
              title: 'العربية',
              isSelected: false,
              onPressed: () {
                // Will select arabic language
                if (BlocProvider.of<AppLangBloc>(context).state.appLocal !=
                    const Locale('ar')) {
                  BlocProvider.of<AppLangBloc>(context)
                      .add(AppLangEvent(appLocal: const Locale("ar")));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(
                        email: FirebaseAuth.instance.currentUser!.email,
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslatedData(context, "settings"),
        ctx: context,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Material(
              type: MaterialType.card,
              shadowColor: Theme.of(context).shadowColor,
              color: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: InkWell(
                onTap: () => buildShowDialog(context),
                child: SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.90,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      // vertical: 10.0,
                    ),
                    child: SizedBox(
                      height: 57,
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 10,
                      //   vertical: 2,
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslatedData(context, "theLang").toString(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                          ),
                          BlocProvider.of<AppLangBloc>(context)
                                      .state
                                      .appLocal ==
                                  const Locale('ar')
                              ? const Text("العربية")
                              : const Text("English"),
                          // FutureBuilder<String?>(
                          //   future: sharedPrefsServices.getCurrentLanguage(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasData && snapshot.data != null) {
                          //       String? data = snapshot.data;
                          //       if (data == 'en') {
                          //         return Text(
                          //           'English',
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .subtitle2!
                          //               .copyWith(
                          //                 color: Palette.greyColor,
                          //               ),
                          //         );
                          //       } else {
                          //         return Text(
                          //           'العربية',
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .subtitle2!
                          //               .copyWith(
                          //                 color: Palette.greyColor,
                          //               ),
                          //         );
                          //       }
                          //     }
                          //     return const SizedBox();
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Divider(
              indent: 10,
              endIndent: 10,
            ),

            const SizedBox(height: 20),
            // Profile data - label
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Text(
                // "الملف الشخصي",
                getTranslatedData(context, "profileInfo"),
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Palette.primaryColor,
                    ),
              ),
            ),

            const SizedBox(height: 7),

            // Second selector
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Material(
                type: MaterialType.card,
                shadowColor: Theme.of(context).shadowColor,
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesPaths.editFullName);
                  },
                  child: Container(
                    height: 57,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslatedData(context, "name"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),

                            const _CurrentUserFullName(),
                            // End
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Second selector
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Material(
                type: MaterialType.card,
                shadowColor: Theme.of(context).shadowColor,
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesPaths.updateMobileNoScreen,
                    );
                  },
                  child: Container(
                    height: 57,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phone_android_sharp,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslatedData(context, "mobileNumber"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),

                            const _GetCurrentPhoneNumber(),
                            // Endss
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // // Second selector
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 12.0),
            //   child: Material(
            //     type: MaterialType.card,
            //     shadowColor: Theme.of(context).shadowColor,
            //     color: Colors.transparent,
            //     shape: const RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //     ),
            //     child: InkWell(
            //       onTap: () {},
            //       child: Container(
            //         height: 57,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 22,
            //           vertical: 2,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Icon(
            //               Icons.lock_outline_sharp,
            //               color: Colors.grey.shade600,
            //             ),
            //             const SizedBox(width: 20),
            //             Text(
            //               "تغيير كلمة المرور",
            //               style:
            //                   Theme.of(context).textTheme.subtitle2!.copyWith(
            //                         color: Colors.grey.shade600,
            //                       ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // Ends
          ],
        ),
      ),
    );
  }
}

class _CurrentUserFullName extends StatelessWidget {
  const _CurrentUserFullName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: AppCollections.users.doc(currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Text(
            snapshot.data!["fullName"] as String,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: const Color.fromARGB(255, 14, 14, 14),
                ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _GetCurrentPhoneNumber extends StatelessWidget {
  const _GetCurrentPhoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: AppCollections.users.doc(currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            snapshot.data == null &&
            currentUser.phoneNumber != null) {
          return Text(
            currentUser.phoneNumber ?? "+20",
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return Text(
            snapshot.data!.get("mobileNo") ?? "أضف رقم هاتفك",
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.grey.shade600,
                ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
