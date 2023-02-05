import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ladytabtab/src/constants/routes/routes.dart';

import 'package:ladytabtab/src/models/collection/app_collections.dart';

import '../../../models/product/product_model.dart';
import '../../components/custom_progress_indicator.dart';
import '../../theme/palette.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';
import '../home/product_details.dart';

class WishlistWidget extends StatefulWidget {
  const WishlistWidget({
    Key? key,
    this.hasBackArrow = false,
  }) : super(key: key);

  final bool hasBackArrow;

  @override
  State<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  late PageController pageController;

  int currentIndex = 0;
  int itemIndex = 5;
  bool _isLoading = true;

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

  List<String> listResult = [];
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

  @override
  void initState() {
    super.initState();

    getProdcu();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    _isLoading = false;
    super.dispose();
  }

  List<ProductModel> productModels = [];
  bool isLoading = true;
  Future<void> getProdcu() async {
    await AppCollections.wishlist
        .where("userUid", isEqualTo: currentUserUid)
        .get()
        .then((value) async {
      var docs = value.docs;
      for (var wishlistDoc in docs) {
        await AppCollections.products
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
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return _isLoading
        ? const CustomProgressIndicator()
        : productModels.isEmpty
            ? Center(
                child: Text(
                  getTranslatedData(context, "noWishlistProducts"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Palette.greyColor,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                padding: const EdgeInsets.symmetric(vertical: 50),
                itemCount: productModels.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: _FavoriteCard(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutesPaths.productDetails,
                          arguments: productModels[index],
                        );
                      },
                      productModel: productModels[index],
                    ),
                  );
                },
              );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
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
        color: const Color.fromARGB(255, 248, 244, 244),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide.none,
        ),
        shadowColor: Colors.white38,
        margin: const EdgeInsets.all(5),
        elevation: 0.0,
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
                  : Container(
                      padding: const EdgeInsets.all(2.0),
                      width: 300,
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(
                      productModel.prodName.toString(),
                      style: theme.textTheme.subtitle2!
                          .copyWith(color: Palette.greyColor),
                      overflow: TextOverflow.ellipsis,
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
                                decoration:
                                    productModel.prodPriceWithDiscount == 0.0 ||
                                            productModel
                                                    .prodPriceWithDiscount ==
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
                                          productModel.prodPriceWithDiscount ==
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
    );
  }
}

// TEST
class WishRx extends StatefulWidget {
  const WishRx({Key? key}) : super(key: key);

  @override
  State<WishRx> createState() => _WishRxState();
}

class _WishRxState extends State<WishRx> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _getWishListStream;
  @override
  void initState() {
    super.initState();
    _getWishListStream = AppCollections.wishlist
        .where("userUid", isEqualTo: currentUserUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _getWishListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemBuilder: (context, index) {
              ProductModel productModel = ProductModel();
              AppCollections.products
                  .where(
                    "prodUid",
                    isEqualTo: snapshot.data!.docs[index]['productId'],
                  )
                  .get()
                  .then((value) {
                setState(() {
                  productModel =
                      ProductModel.fromJson(value.docs[index].data());
                });
              });

              return ProductDetailsScreen(productModel: productModel);
            },
          );
        }
        return const CustomProgressIndicator();
      },
    );
  }
}

class ViewProduct extends StatelessWidget {
  const ViewProduct({
    Key? key,
    required this.productId,
  }) : super(key: key);
  final String productId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future:
          AppCollections.products.where("prodUid", isEqualTo: productId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var doc = snapshot.data!.docs.first;
          ProductModel productModel = ProductModel.fromJson(doc.data());
          return ProductDetailsScreen(productModel: productModel);
        }
        return const CustomProgressIndicator();
      },
    );
  }
}
