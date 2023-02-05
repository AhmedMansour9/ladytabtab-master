import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../radiuz.dart';

// final currentUser = FirebaseAuth.instance.currentUser;
// final String? currentUserUid = currentUser!.uid;

const OutlineInputBorder kOutlineInputBorderActive = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: Radiuz.smallRadius,
);

const size = Size(50, 50);
const kRoundedBag = "assets/images/svg/Bag.svg";
const kLadyIcon = 'assets/images/ladyicon.png';
const kSplashLogo = "assets/images/ic_lady.png";
// const whatsappIcon = 'assets/images/svg/whatsapp.svg';
const facebookIcon = 'assets/images/f_logo_512.png';
// Profile icons
const kProfileBag = "assets/images/svg/bags.svg";
const kProfileWishlist = "assets/images/svg/wishlist_fa.svg";
const kProfileAddress = "assets/images/svg/address_ic.svg";
// Profile list tile icons
const kProfileMyAccount = "assets/images/svg/account.svg";
const kProfileSettings = "assets/images/svg/Settings.svg";
const kProfileHelp = "assets/images/svg/Questionmark.svg";
const kProfileContactUs = "assets/images/svg/Offer.svg";
const kProfileLogOut = "assets/images/svg/Logout.svg";
const kDeleteIcon = "assets/images/svg/Delete.svg";
const kAddressIcon = "assets/images/svg/Address.svg";

// Logo
const kLogoIcon = 'assets/images/svg/logo.svg';
const kFacebookIcon = 'assets/images/svg/fb.svg';
const kGoogleIcon = 'assets/images/svg/google.svg';
const kAppleIcon = 'assets/images/apple_logo.svg';
const kAppleLogo = 'assets/images/apple_logo.png';

const kBagIcon = "assets/images/svg/Bag.svg";
const kSearchIcon = 'assets/images/svg/Searchi.svg';

// Icons & Images - assets
const kHomeIcon = 'assets/images/svg/Home.svg';
const kHomeFilledIcon = 'assets/images/svg/Home_fill.svg';

const kExploreIcon = 'assets/images/svg/Explore.svg';
const kExploreFilledIcon = 'assets/images/svg/explore_fill.svg';

const kWishlistIcon = 'assets/images/svg/Wishlist.svg';
const kWishlistFilledIcon = 'assets/images/svg/Heart_fill.svg';

const kProfileIcon = 'assets/images/svg/Profile.svg';
const kProfileFilledIcon = 'assets/images/svg/user_fill.svg';

// Order successfully done
const kTransactionIcon = 'assets/images/success_transactions.svg';

const kEmptyCartIcon = "assets/images/svg/empty_cart.svg";

printDebugMode(String text) {
  if (kDebugMode) {
    print(text);
  }
}
