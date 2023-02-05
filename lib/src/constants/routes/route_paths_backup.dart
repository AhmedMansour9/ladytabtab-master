// import 'package:flutter/material.dart';
// import 'package:ladytabtab/src/view/screens/wishlist/wishlist_view.dart';

// import '../../models/order/order_model.dart';
// import '../../models/product/product_model.dart';
// import '../../view/components/shared/splash_screen.dart';
// import '../../view/screens/auth/login_screen.dart';
// import '../../view/screens/auth/register_screen.dart';
// import '../../view/screens/contact/contact_us_screen.dart';
// import '../../view/screens/edit_user/edit_fullname.dart';
// import '../../view/screens/home/product_details.dart';
// import '../../view/screens/main/main_screen.dart';
// import '../../view/screens/onboarding/onboarding_screens.dart';
// import '../../view/screens/orders/orders_screen.dart';
// import '../../view/screens/profile/chat/easy_chat_screen.dart';
// import '../../view/screens/profile/phone_auth_screen.dart';
// import '../../view/screens/profile/settings.dart';
// import '../../view/screens/search/filter_result_screen.dart';
// import '../../view/screens/search/filter_screen.dart';
// import '../../view/screens/search/search_screen.dart';
// import '../../view/screens/shipping/address_screen.dart';
// import '../../view/screens/shipping/edit_user_address.dart';
// import '../../view/screens/wishlist/wishlist_screen.dart';
// import '../../view/widgets/view_image.dart';
// import 'custom_navigator.dart';
// import 'routes.dart';

// class AppRoutes {
//   // GENERATE ROUTES
//   static Route generateRoutes(RouteSettings routeSettings) {
//     switch (routeSettings.name) {
//       case RoutesPaths.onBoardingScreens:
//         return MaterialPageRoute(builder: (_) => const OnBoardingScreens());
//       case RoutesPaths.mainScreens:
//         return MaterialPageRoute(builder: (_) => const MainScreen());
//       case RoutesPaths.editFullName:
//         return MaterialPageRoute(builder: (_) => const EditFullName());
//       case RoutesPaths.filterResult:
//         return MaterialPageRoute(builder: (_) => const FilterResultScreen());
//       case RoutesPaths.productDetails:
//         final ProductModel productModel =
//             routeSettings.arguments as ProductModel;
//         return CustomRouteBuilder(
//           child: ProductDetailsScreen(productModel: productModel),
//         );
//       case RoutesPaths.updateMobileNoScreen:
//         return MaterialPageRoute(builder: (_) => const UpdateMobileNoScreen());
//       case SearchScreen.route:
//         return MaterialPageRoute(builder: (_) => const SearchScreen());
//       case LoginScreen.route:
//         return MaterialPageRoute(builder: (_) => const LoginScreen());
//       case FilterScreen.route:
//         return MaterialPageRoute(builder: (_) => const FilterScreen());
//       case RegisterScreen.route:
//         return MaterialPageRoute(builder: (_) => const RegisterScreen());

//       // case VerificationNumberScreen.route:
//       //   final mobileNo = routeSettings.arguments as String;
//       //   return CustomRouteBuilder(
//       //       child: VerificationNumberScreen(mobileNumber: mobileNo));
//       case AddressScreen.route:
//         final bool hasButton = routeSettings.arguments as bool;
//         return CustomRouteBuilder(
//           child: AddressScreen(hasButton: hasButton),
//         );
//       case SettingsScreen.route:
//         return MaterialPageRoute(builder: (_) => const SettingsScreen());
//       case OrdersScreen.route:
//         return MaterialPageRoute(builder: (_) => const OrdersScreen());
//       case OrderDetails.route:
//         final userOrdersModel = routeSettings.arguments as OrderModel;
//         return CustomRouteBuilder(
//           child: OrderDetails(userOrdersModel: userOrdersModel),
//         );
//       case EditUserAddress.route:
//         final String addressDocId = routeSettings.arguments as String;

//         return CustomRouteBuilder(
//           child: EditUserAddress(selectedAddressId: addressDocId),
//         );
//       case RoutesPaths.wishlistWidget:
//         final bool hasBackArrow = routeSettings.arguments as bool;
//         return CustomRouteBuilder(
//           child: WishlistWidget(hasBackArrow: hasBackArrow),
//         );
//       case RoutesPaths.wishlistViewScreen:
//         final bool hasBackArrow = routeSettings.arguments as bool;
//         return CustomRouteBuilder(
//           child: WishlistViewScreen(hasBackArrow: hasBackArrow),
//         );
//       case EasyChatScreen.route:
//         return MaterialPageRoute(builder: (_) => const EasyChatScreen());
//       case ContactUsScreen.route:
//         return MaterialPageRoute(builder: (_) => const ContactUsScreen());
//       case RoutesPaths.viewImage:
//         final String imageUrl = routeSettings.arguments as String;
//         return MaterialPageRoute(builder: (_) => ViewImage(imageUrl: imageUrl));
//       default:
//         return MaterialPageRoute(builder: (_) => const SplashScreen());
//     }
//   }
// }
