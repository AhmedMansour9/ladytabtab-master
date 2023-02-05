import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/collection/app_collections.dart';
import 'shared/screens_size.dart';
import 'radiuz.dart';

import '../../models/product/product_model.dart';
import '../../models/product/wishlist_model.dart';
import 'custom_logo.dart';
import '../theme/palette.dart';
import 'shared/get_translated_data.dart';

class ExploreProductCard extends StatelessWidget {
  const ExploreProductCard({
    Key? key,
    required this.productModel,
    required this.onPressed,
  }) : super(key: key);
  final ProductModel productModel;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    ScreenSize().init(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 90,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          color: Palette.cardColor,
          borderRadius: Radiuz.mediumRadius,
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  // color: Palette.unactiveIconColor,
                  color: Colors.grey.shade200,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              // child: Image.asset('assets/images/svg/mk.png'),
              child: productModel.prodImgUrl == null ||
                      productModel.prodImgUrl!.isEmpty
                  ? const Center(
                      child: CustomLogo(size: 55),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: CachedNetworkImage(
                        imageUrl: productModel.prodImgUrl.toString(),
                        fit: BoxFit.cover,
                        // fit: BoxFit.contain,
                        width: 80,
                        // placeholder: (context, url) {
                        //   // return const CustomProgressIndicator();
                        // },
                        errorWidget: (context, url, error) {
                          return const Center(child: CustomLogo(size: 55));
                        },
                      ),
                    ),
            ),

            // Title
            Expanded(
              child: SizedBox(
                width: ScreenSize.screenWidth! * 0.90,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          productModel.prodName!,
                          style: textTheme.subtitle2!.copyWith(
                            color: Palette.blackColor,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          productModel.prodDetails!,
                          style: textTheme.subtitle2!.copyWith(
                            color: Colors.grey.shade700,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                if (productModel.prodPriceWithDiscount! > 0.0)
                                  Text(
                                    "${productModel.prodPriceWithDiscount!} ${getTranslatedData(context, "egyPrice")}",
                                    style:
                                        const TextStyle(color: Colors.orange),
                                  ),
                                if (productModel.prodPriceWithDiscount! > 0.0)
                                  const SizedBox(width: 5),
                                Text(
                                  "${productModel.prodPrice} ${getTranslatedData(context, "egyPrice")}",
                                  style: TextStyle(
                                    color: productModel.prodPriceWithDiscount ==
                                            0.0
                                        ? Colors.orange
                                        : Palette.greyColor,
                                    decoration:
                                        productModel.prodPriceWithDiscount ==
                                                0.0
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough,
                                    decorationStyle: TextDecorationStyle.solid,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (FirebaseAuth.instance.currentUser != null)
                            FavoriteButton(
                              prodUid: productModel.prodUid!,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.prodUid,
  }) : super(key: key);

  final String prodUid;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _productsStream;
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _productsStream = AppCollections.wishlist
        .where(
          "prodUid",
          isEqualTo: widget.prodUid,
        )
        .where("userUid", isEqualTo: currentUserUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _productsStream,
        builder: (context, snapshot) {
          debugPrint("## Streams - Product Card ##");
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.docs.isNotEmpty) {
            return RawMaterialButton(
              constraints: const BoxConstraints(
                maxHeight: 33,
                maxWidth: 33,
              ),
              shape: const CircleBorder(),
              fillColor: Colors.transparent,
              elevation: 0.0,
              focusElevation: 0.0,
              highlightElevation: 0.0,
              padding: const EdgeInsets.all(5),
              onPressed: () async {
                await AppCollections.wishlist
                    .where(
                      "prodUid",
                      isEqualTo: widget.prodUid,
                    )
                    .where(
                      "userUid",
                      isEqualTo: currentUserUid,
                    )
                    .get()
                    .then((value) {
                  AppCollections.wishlist.doc(value.docs.first.id).delete();

                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg: "تم حذف المنتج من المفضلات",
                  );
                });
              },
              child: const Icon(
                Icons.favorite,
                color: Color(0xFFF64343),
              ),
            );
          } else {
            return RawMaterialButton(
              constraints: const BoxConstraints(
                maxHeight: 33,
                maxWidth: 33,
              ),
              shape: const CircleBorder(),
              fillColor: Colors.transparent,
              elevation: 0.0,
              focusElevation: 0.0,
              highlightElevation: 0.0,
              padding: const EdgeInsets.all(5),
              onPressed: () async {
                // setState(() {
                //   isFavorite = !isFavorite;
                // });

                String docId = AppCollections.wishlist.doc().id;
                WishlistModel wishlistModel = WishlistModel(
                  prodUid: widget.prodUid,
                  userUid: currentUserUid,
                );
                var data = wishlistModel.toMap();
                await AppCollections.wishlist.doc(docId).set(
                      data,
                      SetOptions(merge: true),
                    );

                Fluttertoast.cancel();
                Fluttertoast.showToast(
                  msg: "تم إضافة المنتج إلى المفضلات",
                );
              },
              child: Icon(
                Icons.favorite_border,
                color: Colors.grey.shade300,
                // size: 29,
              ),
            );
          }
        },
      ),
    );
  }
}
