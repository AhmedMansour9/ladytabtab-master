import 'package:ladytabtab/src/models/collection/app_collections.dart';

class ProductServices {
  Future<int> getAvailableItemById(String productId) async {
    late int currentAvailableItem;
    await AppCollections.products.doc(productId).get().then(
          (product) => currentAvailableItem = product.get('prodAvailableQty'),
        );

    return currentAvailableItem;
  }

  Future<int> getProductAvailableQty(String cartProdId) async {
    int qty = 0;
    await AppCollections.products
        .where("prodUid", isEqualTo: cartProdId)
        .get()
        .then((data) {
      qty = data.docs.single.get("prodAvailableQty");
    });

    return qty;
  }
}
