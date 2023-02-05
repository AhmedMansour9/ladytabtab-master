import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/collection/collection_model.dart';
import '../../models/product/product_model.dart';

class ProductsServices {
  ProductModel _getProduct(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return ProductModel.fromJson(snapshot.docs.first.data());
  }

  Stream<ProductModel> getProduct(
    CollectionReference<Map<String, dynamic>> collection,
  ) {
    return collection.snapshots().map(_getProduct);
  }

  // Stream<List<ProductModel>> getProductsByCategory(
  //   CollectionModel collectionModel,
  // ) {
  //   return collectionModel.collection
  //       .where("prodCategory", isEqualTo: collectionModel.category)
  //       .snapshots()
  //       .map(_getProductsList);
  // }

  Future<List<ProductModel>> getProductsByCategory(
    CollectionModel collectionModel,
  ) {
    return collectionModel.collection
        .where("prodCategory", isEqualTo: collectionModel.category)
        .get()
        .then(
          (value) => value.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
