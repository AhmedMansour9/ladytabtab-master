import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ladytabtab/src/models/collection/app_collections.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';
import 'package:ladytabtab/src/view/screens/offers/offers_screen.dart';

import '../../../../exports_main.dart';
import '../../widgets/cart_button_counter.dart';
import '../home/gategories/category_card.dart';
import '../home/home_screen.dart';
import '../home/home_slider.dart';
import 'no_internet_connection.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, this.locale}) : super(key: key);

  final Locale? locale;

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const _CustomHomeScreen(),
    const OffersScreen(),
    if (FirebaseAuth.instance.currentUser != null) const WishlistWidget(),
    FirebaseAuth.instance.currentUser != null
        ? const ProfileScreen()
        : const NoAuthProfileScreen(),
  ];
  DateTime? currentBackPressTime;
  late String contentText;
  late String yes;
  late String no;
  late TokenApi tokenApi;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    contentText = getTranslatedData(context, "exitApp");
    yes = getTranslatedData(context, "yes");
    no = getTranslatedData(context, "no");
    super.didChangeDependencies();
  }

  checkInternetConn() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      tokenApi = TokenApi();
      tokenApi.fcmConfig();
      if (FirebaseAuth.instance.currentUser == null) {
        // FirebaseAuth.instance.signOut().then((value) {
        //   Navigator.pushNamed(context, LoginScreen.route);
        // });
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          tokenApi.saveToken();
        });
      }
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const NoInternetConnection(),
          ),
          (route) => false,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkInternetConn();
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) async {
        showAlert(context);
      },
    );
  }

  Future<void> showAlert(BuildContext contexts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasAddress = prefs.getBool('hasAddress') ?? false;
    if (FirebaseAuth.instance.currentUser != null && hasAddress) {
    } else if (FirebaseAuth.instance.currentUser != null && !hasAddress) {
      await showDialog<void>(
        context: contexts,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: const [
                Icon(
                  Icons.location_on_outlined,
                  color: Color.fromARGB(255, 232, 49, 110),
                ),
                Text("حدثي عنوانك دلوقتي"),
              ],
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Palette.primaryColor),
                ),
                // fillColor: Palette.primaryColor,
                // elevation: 0.0,
                // focusElevation: 0.0,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(5),
                // ),
                child: const Text(
                  "قائمة العناوين",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddressScreen.route, arguments: false)
                      .then(
                        (value) => Navigator.of(context).pop(),
                      );
                },
              ),
              TextButton(
                // style: ButtonStyle(
                //   backgroundColor:
                //       MaterialStateProperty.all(Colors.grey.shade100),
                // ),
                child: const Text("إلغاء"),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        },
      );
      prefs.setBool("hasAddress", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    ScreenSize().init(context);
    return WillPopScope(
      onWillPop: () async {
        bool exit = false;
        if (scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          exit = false;
        } else {
          if (currentIndex > 0) {
            setState(() {
              currentIndex = 0;
            });
          } else if (currentIndex == 0) {
            await showDialog(
              context: scaffoldKey.currentContext!,
              builder: (context) {
                return Directionality(
                  textDirection: widget.locale == const Locale("ar")
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    content: Text(contentText),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          exit = true;
                        },
                        child: Text(yes),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Palette.primaryColor.withOpacity(0.1),
                          primary: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          exit = false;
                        },
                        child: Text(no),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
        return exit;
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: screens[currentIndex],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: NavigationBar(
            // animationDuration: ,
            backgroundColor: Colors.white,
            selectedIndex: currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  kHomeIcon,
                  color: Palette.blackColor,
                ),
                label: getTranslatedData(context, "homeNav"),
                selectedIcon: SvgPicture.asset(
                  kHomeFilledIcon,
                  color: Palette.primaryColor,
                ),
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  kExploreIcon,
                  color: Palette.blackColor,
                ),
                label: getTranslatedData(context, "exploreNav"),
                selectedIcon: SvgPicture.asset(
                  kExploreFilledIcon,
                  color: Palette.primaryColor,
                ),
              ),
              if (firebaseUser != null)
                NavigationDestination(
                  icon: SvgPicture.asset(
                    kWishlistIcon,
                    color: Palette.blackColor,
                  ),
                  label: getTranslatedData(context, "wishlistNav"),
                  selectedIcon: SvgPicture.asset(
                    kWishlistFilledIcon,
                    color: Palette.primaryColor,
                  ),
                ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  kProfileIcon,
                  color: Palette.blackColor,
                ),
                label: getTranslatedData(context, "myAccount"),
                selectedIcon: SvgPicture.asset(
                  kProfileFilledIcon,
                  color: Palette.primaryColor,
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   // height: 65,
        //   decoration: BoxDecoration(
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(17),
        //       topRight: Radius.circular(17),
        //     ),
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(
        //         blurRadius: 30,
        //         color: Colors.grey.shade300,
        //       ),
        //     ],
        //   ),
        //   child: BottomNavigationBar(
        //     currentIndex: currentIndex,
        //     type: BottomNavigationBarType.fixed,
        //     backgroundColor: Colors.transparent,
        //     unselectedItemColor: Palette.unactiveIconColor,
        //     selectedItemColor: Palette.primaryColor,
        //     unselectedFontSize: 13.0,
        //     selectedFontSize: 13.0,
        //     iconSize: 25,
        //     elevation: 0.0,
        //     landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        //     onTap: (val) {
        //       setState(() {
        //         currentIndex = val;
        //       });
        //     },
        //     items: [
        //       BottomNavigationBarItem(
        //         icon: SvgPicture.asset(
        //           kHomeIcon,
        //           color: Palette.unactiveIconColor,
        //         ),
        //         label: getTranslatedData(context, "homeNav"),
        //         activeIcon: SvgPicture.asset(
        //           kHomeFilledIcon,
        //           color: Palette.primaryColor,
        //         ),
        //       ),
        //       BottomNavigationBarItem(
        //         icon: SvgPicture.asset(
        //           kExploreIcon,
        //           color: Palette.unactiveIconColor,
        //         ),
        //         label: getTranslatedData(context, "exploreNav"),
        //         activeIcon: SvgPicture.asset(
        //           kExploreFilledIcon,
        //           color: Palette.primaryColor,
        //         ),
        //       ),
        //       if (firebaseUser != null)
        //         BottomNavigationBarItem(
        //           icon: SvgPicture.asset(
        //             kWishlistIcon,
        //             color: Palette.unactiveIconColor,
        //           ),
        //           label: getTranslatedData(context, "wishlistNav"),
        //           activeIcon: SvgPicture.asset(
        //             kWishlistFilledIcon,
        //             color: Palette.primaryColor,
        //           ),
        //         ),
        //       BottomNavigationBarItem(
        //         icon: SvgPicture.asset(
        //           kProfileIcon,
        //           color: Palette.unactiveIconColor,
        //         ),
        //         label: getTranslatedData(context, "myAccount"),
        //         activeIcon: SvgPicture.asset(
        //           kProfileFilledIcon,
        //           color: Palette.primaryColor,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        drawer: currentIndex == 3 ? null : const CustomDrawer(),
      ),
    );
  }
}

class _CustomHomeScreen extends StatefulWidget {
  const _CustomHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<_CustomHomeScreen> createState() => __CustomHomeScreenState();
}

class __CustomHomeScreenState extends State<_CustomHomeScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _categoriesStream;

  @override
  void initState() {
    super.initState();
    _categoriesStream = AppCollections.categories.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SLIVER APP BAR
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          stretch: true,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          expandedHeight: ScreenSize.screenHeight! * 0.30,
          collapsedHeight: ScreenSize.screenHeight! * 0.05,
          toolbarHeight: ScreenSize.screenHeight! * 0.05,
          leading: IconButton(
            splashRadius: 24,
            icon: SvgPicture.asset(
              kSearchIcon,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.route);
            },
          ),
          automaticallyImplyLeading: false,
          actions: const [
            TopCartCounter(),
          ],
          flexibleSpace: const FlexibleSpaceBar(
            background: HomeSliderViewTest(),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 11,
            ),
            child: Text(
              getTranslatedData(context, "explore_categories"),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),

        // SLIVER GRID
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _categoriesStream,
          builder: (context, snapshot) {
            debugPrint("## Streams - Home Screen (Category) ##");
            if (snapshot.hasData) {
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: ScreenSize.screenWidth! / 2,

                  // SPACES
                  mainAxisSpacing: 20,
                  // crossAxisSpacing: 5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CategoryCard(
                          categoryName: snapshot.data!.docs[index]
                              .data()["categoryName"]
                              .toString(),
                          categoryImageUrl: snapshot.data!.docs[index]
                                  .data()["categoryImageUrl"] ??
                              "",
                        ),
                        // const SizedBox(height: 7),
                        Expanded(
                          child: Text(
                            snapshot.data!.docs[index]
                                .data()["categoryName"]
                                .toString()
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                  letterSpacing: 2.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromARGB(255, 58, 60, 63),
                                ),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: snapshot.data!.docs.length,
                ),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const CustomProgressIndicator();
                  },
                  childCount: 1,
                ),
              );
            }
          },
        ),

        // END OF SLIVER GRID
      ],
    );
  }
}
