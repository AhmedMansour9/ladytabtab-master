import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/collection/app_collections.dart';
import '../../../models/product/product_model.dart';
import '../../components/custom_progress_indicator.dart';
import '../../theme/palette.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';

class WishlistViewScreen extends StatefulWidget {
  const WishlistViewScreen({
    Key? key,
    this.hasBackArrow = false,
  }) : super(key: key);

  final bool hasBackArrow;

  @override
  State<WishlistViewScreen> createState() => _WishlistViewScreenState();
}

class _WishlistViewScreenState extends State<WishlistViewScreen> {
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  late PageController pageController;

  int currentIndex = 0;
  int itemIndex = 5;

  bool isLoading = true;
  List<String> listResult = [];

  removeUnlistedProduct() async {
    var listProductsItems = [];
    var listWishlistItems = [];

    await AppCollections.wishlist
        .where('userUid', isEqualTo: currentUserUid)
        .get()
        .then((value) {
      var docs = value.docs;

      for (var wishlistDoc in docs) {
        if (!listWishlistItems.contains(wishlistDoc.data()['productId'])) {
          listWishlistItems.add(wishlistDoc.data()['productId']);
        }
        AppCollections.products.get().then((value) {
          var docs = value.docs;
          for (var productsDoc in docs) {
            if (!listProductsItems.contains(productsDoc.data()['productId'])) {
              listProductsItems.add(productsDoc.data()['productId']);
            }
            if (!listWishlistItems.contains(productsDoc)) {
              AppCollections.wishlist
                  .doc(wishlistDoc.data()['productId'])
                  .delete();
            } else {}
          }
        });
      }
    });
  }

  Future<List<String>> getWishlistProdsUids() async {
    debugPrint("getWishlistProds");
    await AppCollections.wishlist
        .where('userUid', isEqualTo: currentUserUid)
        .get()
        .then((value) {
      var docs = value.docs;
      for (var wishlistDoc in docs) {
        listResult.add(wishlistDoc.data()['prodUid']);
      }
    });
    return listResult;
  }

  List<ProductModel> productModels = [];
  Future<List<ProductModel>> getProdcu() async {
    await AppCollections.wishlist
        .where("userUid", isEqualTo: currentUserUid)
        .get()
        .then((value) {
      var docs = value.docs;
      for (var wishlistDoc in docs) {
        AppCollections.products
            .where("prodUid", isEqualTo: wishlistDoc.get("prodUid"))
            .get()
            .then((value) {
          var docs = value.docs;
          for (var element in docs) {
            ProductModel prodModel = ProductModel.fromJson(element.data());
            if (productModels.contains(prodModel)) {
            } else {
              productModels.add(prodModel);
            }
          }
        });
      }
    });
    return productModels;
  }

  @override
  void initState() {
    super.initState();

    getProdcu();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return isLoading
        ? const CustomProgressIndicator()
        : Scaffold(
            body: FutureBuilder<List<ProductModel>>(
              future: getProdcu(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return SizedBox(
                    height: ScreenSize.screenHeight! * 0.80,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 222,
                          child: CustomFavoriteCard(
                            onPressed: () {},
                            productModel: snapshot.data![index],
                          ),
                        );
                      },
                    ),
                  );
                }
                return const CustomProgressIndicator();
              },
            ),
          );
    // return Container(
    //   color: Palette.mainColor,
    //   width: MediaQuery.of(context).size.width,
    //   child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //     future: AppCollections.products
    //         .where("prodUid", isEqualTo: "prodUid")
    //         .get(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const CustomProgressIndicator();
    //       } else if (snapshot.hasData &&
    //           snapshot.connectionState == ConnectionState.done) {
    //         var dataAll = snapshot.data;
    //         var productModels = dataAll!.docs.map((e) {
    //           return ProductModel.fromJson(e.data());
    //         }).toList();

    //         return GridView(
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2,

    //             // Size of each widget
    //             childAspectRatio:
    //                 ScreenSize.screenWidth! / (ScreenSize.screenHeight! / 1.5),
    //             // Spaces
    //             mainAxisSpacing: 10,
    //             crossAxisSpacing: 10,
    //           ),
    //           padding: const EdgeInsets.symmetric(
    //             vertical: 10,
    //             horizontal: 10,
    //           ),
    //           children: List.generate(listResult.length, (index) {
    //             return const Card(color: Colors.blue);
    //           }),
    //           // return CustomFavoriteCard(
    //           //   productModel: productModels[index],
    //           //   onPressed: () {
    //           //     // Navigator.pushNamed(context, Routes.productDetails,
    //           //     //     arguments: productModels[index]);
    //           //     Navigator.push(
    //           //       context,
    //           //       MaterialPageRoute(
    //           //         builder: (context) {
    //           //           return ProductDetailsScreen(
    //           //             productModel: productModels[index],
    //           //             // isWishListItem: true,
    //           //             productId: productModels[index].prodUid,
    //           //           );
    //           //         },
    //           //       ),
    //           //     );
    //           //   },
    //           // );
    //         );
    //       } else {
    //         return const Center(
    //           child: Text(
    //             "No data",
    //             style: TextStyle(
    //               fontSize: 20,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}

class CustomFavoriteCard extends StatelessWidget {
  const CustomFavoriteCard({
    Key? key,
    required this.onPressed,
    required this.productModel,
  }) : super(key: key);

  final ProductModel productModel;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        shadowColor: Colors.white38,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4.0),
              Expanded(
                flex: 1,
                child: productModel.prodImgUrl == null ||
                        productModel.prodImgUrl!.isEmpty
                    ? SizedBox(
                        width: 90,
                        child: SvgPicture.asset(
                          kLogoIcon,
                          color: Palette.greyColor,
                        ),
                      )
                    : SizedBox(
                        width: 150,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                          child: CachedNetworkImage(
                            imageUrl: productModel.prodImgUrl!,
                            fit: BoxFit.cover,
                            // width: 130,
                            // placeholder: (context, url) {
                            //   return const CustomProgressIndicator();
                            // },
                          ),
                        ),
                      ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  // width: MediaQuery.of(context).size.width * 0.40,
                  // alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  // color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Text(
                        productModel.prodName.toString(),
                        style: theme.textTheme.subtitle2!
                            .copyWith(color: Palette.greyColor),
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                      ),
                      // const SizedBox(height: 4.0),
                      Text(
                        productModel.prodDetails.toString(),
                        style: theme.textTheme.subtitle2!.copyWith(
                          color: Palette.blackColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${productModel.prodPrice} ${getTranslatedData(context, "egyPrice")}',
                                style: theme.textTheme.subtitle1!.copyWith(
                                  color: productModel.prodPriceWithDiscount ==
                                              0.0 ||
                                          productModel.prodPriceWithDiscount ==
                                              null
                                      ? Colors.orange
                                      : Palette.greyColor,
                                  // fontWeight: FontWeight.bold,
                                  decoration: productModel
                                                  .prodPriceWithDiscount ==
                                              0.0 ||
                                          productModel.prodPriceWithDiscount ==
                                              null
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (productModel.prodPriceWithDiscount != null ||
                                productModel.prodPriceWithDiscount! > 0.0)
                              const SizedBox(width: 3),
                            if (productModel.prodPriceWithDiscount == 0.0 ||
                                productModel.prodPriceWithDiscount == null)
                              const SizedBox()
                            else
                              Expanded(
                                child: Text(
                                  '${productModel.prodPriceWithDiscount} ${getTranslatedData(context, "egyPrice")}',
                                  style: theme.textTheme.subtitle1!.copyWith(
                                    color: productModel.prodPriceWithDiscount ==
                                                0.0 ||
                                            productModel
                                                    .prodPriceWithDiscount ==
                                                null
                                        ? Palette.greyColor
                                        : Colors.orange,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // const RatingBar(rating: 3.5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
