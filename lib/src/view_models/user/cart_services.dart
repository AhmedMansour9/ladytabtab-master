import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/cart/cart_model.dart';
import '../../models/category/category_model.dart';
import '../../models/collection/app_collections.dart';

class CartServices {
  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  // Add a item to cart
  Future addItemToCart({
    required int? qty,
    required String? itemId,
    required String? prodCategory,
    required String? prodName,
    required String? prodDetails,
    required double? prodPrice,
    required String? prodImgUrl,
    required int? itemQty,
    required bool? isAvailable,
    required int? selectedColorIndex,
    required String? smellName,
  }) async {
    final newCartDocId = AppCollections.cart.doc().id;

    CartModel cartModelData = CartModel(
      qty: 1,
      cartItemId: newCartDocId,
      prodCategory: prodCategory,
      productId: itemId,
      prodName: prodName,
      prodDetails: prodDetails,
      prodPrice: prodPrice,
      itemImgUrl: prodImgUrl,
      prodIsAvailable: isAvailable,
      totalPrice: prodPrice! * qty! + 0.0,
      userId: currentUserUid,
      selectedColorIndex: selectedColorIndex,
      smellName: smellName,
    );

    //

    AppCollections.cart.doc(newCartDocId).set(cartModelData.toMap());
  }

  Future<void> _updateMyQty({
    required String cartItemId,
    required String productId,
    required isIncrease,
  }) async {
    // will update availabe
    await AppCollections.cart.doc(cartItemId).update(
      {
        'qty': FieldValue.increment(isIncrease ? 1 : -1),
      },
    );
  }

  Future<void> _updateMyPrice({
    required String cartItemIds,
    required double currentPrice,
    required int cartQty,
  }) async {
    if (cartItemIds.isNotEmpty) {
      if (AppCollections.cart.id.isNotEmpty) {
        var result = await AppCollections.cart.doc(cartItemIds).get();

        if (result.exists &&
            cartItemIds.isNotEmpty &&
            cartQty > 0 &&
            currentPrice > 0 &&
            AppCollections.cart.id.isNotEmpty) {
          var totalPrice = cartQty * currentPrice;
          if (cartItemIds.isNotEmpty && cartItemIds != "") {
            await AppCollections.cart
                .doc(cartItemIds)
                .get()
                .then((value) async {
              if (value.exists) {
                await AppCollections.cart
                    .doc(cartItemIds)
                    .update({'totalPrice': totalPrice});
              } else {}
            });
          }
        }
      }
    }
  }

  Future<void> updateQtyAndPrice({
    required String productId,
    required int qty,
    required bool isIncrease,
  }) async {
    await AppCollections.cart.get().then((val) async {
      for (var doc in val.docs) {
        if (doc.data().containsValue(productId)) {
          CartModel cartModel = CartModel.fromJson(doc.data());
          var cartItemId = doc.id;
          _updateMyQty(
            cartItemId: doc.id,
            isIncrease: isIncrease,
            productId: productId,
          ).then((value) async {
            if (doc.id.isNotEmpty) {
              _updateMyPrice(
                cartItemIds: cartItemId,
                currentPrice: cartModel.prodPrice!,
                cartQty: qty,
              );

              // TODO: UPDATE PRODUCT SELECTED QTY
              // await AppCollections
              //     .collection("Products")
              //     .doc(productId)
              //     .update(
              //   {
              //     'prodAvailableQty': FieldValue.increment(isIncrease ? -1 : 1),
              //     'prodIsAvailable': true,
              //   },
              // );
            }
          });
        }
      }
    });
  }

  // Remove
  Future<void> deleteCartProductById({
    required String cartItemId,
    required String productId,
  }) async {
    // await AppCollections
    //     .collection("Products")
    //     .doc(productId)
    //     .update(
    //   {
    //     'prodAvailableQty': FieldValue.increment(1),
    //     'prodIsAvailable': true,
    //   },
    // );
    await AppCollections.cart.doc(cartItemId).delete();
  }

  Future<void> clearCart() async {
    await AppCollections.cart.get().then((item) {
      for (var doc in item.docs) {
        AppCollections.cart.doc(doc.id).delete();
      }
    });
  }

  Stream<CartDocument> cartQuantity() {
    return AppCollections.cart
        // .where("userId", isEqualTo: currentUserUid)
        .snapshots()
        .map((event) => CartDocument.fromJson(event.docs.length));
  }
  // End
}
