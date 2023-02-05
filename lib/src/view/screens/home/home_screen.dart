import '../../../models/collection/app_collections.dart';
import 'export.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ScreenSize().init(context);
//     return const Categories();
//   }
// }

// class OpenDrawerButton extends StatelessWidget {
//   const OpenDrawerButton({
//     Key? key,
//     required this.scaffoldKey,
//   }) : super(key: key);

//   final GlobalKey<ScaffoldState> scaffoldKey;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppLanguage>(
//       builder: (context, value, child) {
//         return IconButton(
//           // constraints: BoxConstraints(maxHeight: 33, maxWidth: 33),

//           splashRadius: 24,
//           icon: value.appLocal == const Locale("ar")
//               ? SvgPicture.asset(
//                   'assets/images/svg/Menu_rtl.svg',
//                   color: Colors.black54,
//                 )
//               : SvgPicture.asset(
//                   'assets/images/svg/Menu.svg',
//                   color: Colors.black54,
//                 ),
//           onPressed: () {
//             scaffoldKey.currentState!.openDrawer();
//           },
//         );
//       },
//     );
//   }
// }

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  AppLanguage appLanguage = AppLanguage();
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return currentUser == null
        ? const SizedBox()
        : Drawer(
            child: SafeArea(
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 30),
                  DrawerHeader(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 45,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 3),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            currentUser != null
                                ? FutureBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                    future: AppCollections.users
                                        .doc(currentUser!.uid)
                                        .get(),
                                    // initialData: UserModel(),
                                    builder: (
                                      context,
                                      snapshot,
                                    ) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return Text(
                                          snapshot.data!['fullName'].toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                color: Colors.black87,
                                              ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  )
                                : const SizedBox(),
                            // const SizedBox(height: 3),
                            currentUser == null
                                ? const SizedBox()
                                : Text(
                                    '${currentUser!.email}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline!
                                        .copyWith(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Build list tile - (account, settings, help, contact us, and log out)
                  Column(
                    children: [
                      // CustomProfileCard(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => MyAccount(
                      //           fullName: currentUser!.displayName!,
                      //           email: currentUser!.email!,
                      //           mobile: currentUser!.phoneNumber ?? "",
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
                          Navigator.of(context).pop();

                          Navigator.pushNamed(context, SettingsScreen.route);
                        },
                        image: kProfileSettings,
                        title: getTranslatedData(context, "settings"),
                      ),
                      const SizedBox(height: 10),
                      CustomProfileCard(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, OrdersScreen.route);
                        },
                        image: kBagIcon,
                        title: getTranslatedData(context, "myOrders"),
                      ),
                      const SizedBox(height: 10),
                      // CustomProfileCard(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.pushNamed(context, EasyChatScreen.route);
                      //   },
                      //   image: kProfileHelp,
                      //   title: getTranslatedData(context, "help"),
                      // ),
                      // const SizedBox(height: 10),
                      CustomProfileCard(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, ContactUsScreen.route);
                        },
                        image: kProfileContactUs,
                        title: getTranslatedData(context, "contactUs"),
                      ),
                      const SizedBox(height: 10),
                      CustomProfileCard(
                        onPressed: () async {
                          Navigator.of(context).pop();
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
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
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
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
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
          );
  }
}

// class HomeSliderView extends StatefulWidget {
//   const HomeSliderView({Key? key}) : super(key: key);
//   @override
//   State<HomeSliderView> createState() => HomeSliderViewState();
// }

// class HomeSliderViewState extends State<HomeSliderView> {
//   final CarouselController _carouselController = CarouselController();

//   int currentIndex = 0;
//   int nextPage = 0;
//   late int offersLength;

//   late Future<QuerySnapshot<Map<String, dynamic>>> _sliderViewStream;

//   @override
//   void initState() {
//     super.initState();
//     _sliderViewStream =
//         AppCollections.products.where('prodIsOnSlider', isEqualTo: true).get();
//   }

//   @override
//   void dispose() {
//     _carouselController.stopAutoPlay();
//     _sliderViewStream = Future.value();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenSize().init(context);

//     debugPrint("## Home - Slider Viewer Builder ##");

//     return SizedBox(
//       width: double.infinity,
//       child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         future: _sliderViewStream,
//         // stream: null,
//         builder: (context, snapshot) {
//           if (snapshot.hasData &&
//               snapshot.data != null &&
//               snapshot.data!.docs.isNotEmpty) {
//             var length = snapshot.data!.docs.length;
//             return Stack(
//               children: [
//                 NotificationListener<OverscrollIndicatorNotification>(
//                   onNotification: (scroll) {
//                     scroll.disallowIndicator();
//                     return false;
//                   },
//                   // child: PageView.builder(
//                   child: CarouselSlider.builder(
//                     carouselController: _carouselController,
//                     options: CarouselOptions(
//                       viewportFraction: 1.0,
//                       height: ScreenSize.screenHeight,
//                       autoPlay: length > 1 ? true : false,
//                       onPageChanged: (val, reason) {
//                         setState(() {
//                           currentIndex = val;
//                         });
//                       },
//                     ),
//                     itemCount: length,
//                     itemBuilder: (context, index, eall) {
//                       var fetched = snapshot.data!.docs[index];
//                       ProductModel productModel =
//                           ProductModel.fromJson(fetched.data());
//                       SliderModel sliderModel =
//                           SliderModel.fromMap(fetched.data());
//                       sliderModel.itemPriceWithDiscount == 0.0
//                           ? sliderModel.prodPrice.toString()
//                           : sliderModel.itemPriceWithDiscount.toString();

//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(
//                             context,
//                             Routes.productDetails,
//                             arguments: productModel,
//                           );
//                         },
//                         child: SizedBox(
//                           width: ScreenSize.screenWidth!,
//                           child: sliderModel.itemImageUrl == null ||
//                                   sliderModel.itemImageUrl!.isEmpty
//                               ? const Center(
//                                   child: CustomLogo(size: 133),
//                                 )
//                               : CachedNetworkImage(
//                                   width: double.maxFinite,
//                                   imageUrl: sliderModel.itemImageUrl.toString(),
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) {
//                                     return const CustomProgressIndicator();
//                                   },
//                                   errorWidget: (context, url, error) {
//                                     return const Center(
//                                       child: CustomLogo(),
//                                     );
//                                   },
//                                 ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   child: BuildIndicators(
//                     itemIndex: length,
//                     currentIndex: currentIndex,
//                   ),
//                 ),
//               ],
//             );
//           } else if (snapshot.hasData &&
//               snapshot.data != null &&
//               snapshot.data!.docs.isEmpty) {
//             return Padding(
//               padding: const EdgeInsets.all(20),
//               // width: ScreenSize.screenWidth! * 0.92,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(14),
//                 ),
//                 child: Image.asset(
//                   "assets/images/onboarding/slider.png",
//                 ),
//               ),
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }

// class BuildIndicators extends StatelessWidget {
//   const BuildIndicators({
//     Key? key,
//     required this.itemIndex,
//     required this.currentIndex,
//     this.unselectedColor = Palette.unactiveIconColor,
//   }) : super(key: key);

//   final int itemIndex;
//   final int currentIndex;
//   final Color? unselectedColor;

//   @override
//   Widget build(BuildContext context) {
//     ScreenSize().init(context);
//     return SizedBox(
//       width: ScreenSize.screenWidth,
//       height: 20,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(itemIndex, (index) {
//           return AnimatedContainer(
//             alignment: Alignment.center,
//             duration: const Duration(milliseconds: 350),
//             width: index == currentIndex ? 10 : 7,
//             height: index == currentIndex ? 10 : 7,
//             margin: const EdgeInsets.symmetric(horizontal: 5),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: index == currentIndex
//                   ? Palette.primaryColor
//                   : Palette.mainBackgroundColor,
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
