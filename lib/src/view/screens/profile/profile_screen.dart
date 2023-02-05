import 'dart:core';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:ladytabtab/exports_main.dart';
import 'package:ladytabtab/src/models/collection/app_collections.dart';
import 'package:ladytabtab/src/view/components/shared/social_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app.dart';
import '../../../models/user/user_model.dart';
import '../../components/custom_arrow_back.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/lang_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var currentUser = FirebaseAuth.instance.currentUser;

  AppLanguage appLanguage = AppLanguage();

  String? getMobileNumber;

  void _launchUrl() async {
    await launchUrl(
      Uri.parse(SocialLinks.whatsApp),
      mode: LaunchMode.externalApplication,
    );
  }

  Future getCurrentUserData() async {
    if (currentUser != null) {
      await AppCollections.users.get().then((user) {
        for (var userData in user.docs) {
          getMobileNumber = userData.get("mobileNo") ?? "";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  final UserServices _userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                // height: 400,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 270,
                      child: Stack(
                        // fit: StackFit.passthrough,
                        // clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/images/background.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            left: 0,
                            bottom: 63,
                            right: 0,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                FutureBuilder<UserModel>(
                                  future: _userServices.getUserFullNameAndEmail,
                                  // initialData: UserModel(),
                                  builder: (
                                    context,
                                    snapshot,
                                  ) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return Text(
                                        snapshot.data!.fullName.toString(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      );
                                    }
                                    // return const SizedBox();

                                    return const SizedBox();
                                  },
                                ),
                                const SizedBox(height: 3),
                                currentUser == null
                                    ? const SizedBox()
                                    : Text(
                                        '${currentUser!.email}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                              color: Colors.white,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 33,
                            color: Colors.black12,
                            offset: Offset(0.0, 14.0),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            onPressed: () {
                              Navigator.pushNamed(context, OrdersScreen.route);
                            },
                            title: getTranslatedData(context, "myOrders"),
                            img: kProfileBag,
                          ),
                          CustomButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Scaffold(
                                    appBar: AppBar(
                                      leading: CustomArrowBack(ctx: context),
                                      title: Text(
                                        getTranslatedData(
                                          context,
                                          "wishlistNav",
                                        ),
                                      ),
                                    ),
                                    body:
                                        const SafeArea(child: WishlistWidget()),
                                  ),
                                ),
                              );
                              // Navigator.pushNamed(
                              //   context,
                              //   RoutesPaths.wishlistWidget,
                              //   arguments: true,
                              // );
                            },
                            title: getTranslatedData(context, "wishlistNav"),
                            img: kProfileWishlist,
                          ),
                          CustomButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AddressScreen.route,
                                arguments: false,
                              );
                            },
                            title: getTranslatedData(context, "myAddress"),
                            img: kProfileAddress,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Build list tile - (account, settings, help, contact us, and log out)
              Column(
                children: [
                  // CustomProfileCard(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => MyAccount(
                  //           fullName: currentUser!.displayName!,
                  //           email: currentUser!.email!,
                  //           mobile: getMobileNumber ??
                  //               (currentUser!.phoneNumber ?? ""),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   image: kProfileMyAccount,
                  //   title: getTranslatedData(context, "myAccount"),
                  // ),
                  // const SizedBox(height: 10),
                  CustomProfileCard(
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsScreen.route);
                    },
                    image: kProfileSettings,
                    title: getTranslatedData(context, "settings"),
                  ),
                  const SizedBox(height: 10),
                  CustomProfileCard(
                    onPressed: _launchUrl,
                    image: kProfileHelp,
                    title: getTranslatedData(context, "help"),
                  ),
                  const SizedBox(height: 10),
                  CustomProfileCard(
                    onPressed: () {
                      Navigator.pushNamed(context, ContactUsScreen.route);
                    },
                    image: kProfileContactUs,
                    title: getTranslatedData(context, "contactUs"),
                  ),
                  const SizedBox(height: 10),
                  CustomProfileCard(
                    onPressed: () async {
                      if (currentUser == null) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginScreen.route,
                          (route) => false,
                        );
                      }
                      AuthServices authServices = AuthServices();
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // prefs.clear().then((value) async {
                      await showDialog(
                        // context: scaffoldKey.currentContext!,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            content: Text(
                              getTranslatedData(context, "logoutRequest"),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                onPressed: () {
                                  authServices.logOut().then((value) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const MyApp();
                                        },
                                      ),
                                      (route) => false,
                                    );
                                  });
                                },
                                child: Text(
                                  getTranslatedData(context, "yes"),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Palette.primaryColor.withOpacity(0.1),
                                  primary: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  getTranslatedData(context, "no"),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      // });
                    },
                    image: kProfileLogOut,
                    title: getTranslatedData(context, "logOut"),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              // End
            ],
          ),
        ),
      ],
    );
  }
}

class CustomProfileCard extends StatelessWidget {
  const CustomProfileCard({
    Key? key,
    required this.image,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String image;
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      type: MaterialType.card,
      shadowColor: theme.shadowColor,
      color: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          // width: MediaQuery.of(context).size.width * 0.90,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image.isEmpty
                      ? const SizedBox()
                      : SvgPicture.asset(
                          image,
                          width: 21,
                          color: Colors.grey,
                        ),
                  if (image.isNotEmpty) const SizedBox(width: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Palette.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Palette.greyColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.img,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String img;
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(img),
            const SizedBox(height: 12),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class NoAuthProfileScreen extends StatelessWidget {
  const NoAuthProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: ListView(
          children: [
            // Gest
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 255, 247, 235),
              radius: 75,
              child: SvgPicture.asset(
                kLogoIcon,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 50),
            CustomProfileCard(
              onPressed: () {
                Navigator.pushNamed(context, ContactUsScreen.route);
              },
              image: kProfileContactUs,
              title: getTranslatedData(context, "contactUs"),
            ),
            const SizedBox(height: 10),
            CustomProfileCard(
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  LoginScreen.route,
                  // (route) => false,
                );
              },
              image: kProfileMyAccount,
              // title: getTranslatedData(context, "logIn"),
              title: MyTranslate(context, LangText.login).translate,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
