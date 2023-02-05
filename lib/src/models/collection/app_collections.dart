import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionNames {
  static const products = "Products";
  static const wishlist = "Wishlist";
  static const users = "Users";
  static const cart = "Cart";
  static const deliveryFees = "DeliveryFees";
  static const orders = "Orders";
  static const chats = "Chats";
  static const categories = "Categories";
  static const addresses = "Addresses";
}

class AppCollections {
  static CollectionReference<Map<String, dynamic>> products =
      FirebaseFirestore.instance.collection(CollectionNames.products);

  static CollectionReference<Map<String, dynamic>> wishlist =
      FirebaseFirestore.instance.collection(CollectionNames.wishlist);

  static CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection(CollectionNames.users);

  static CollectionReference<Map<String, dynamic>> addresses =
      FirebaseFirestore.instance.collection(CollectionNames.addresses);

  static CollectionReference<Map<String, dynamic>> cart =
      FirebaseFirestore.instance.collection(CollectionNames.cart);

  static CollectionReference<Map<String, dynamic>> deliveryFees =
      FirebaseFirestore.instance.collection(CollectionNames.deliveryFees);

  static CollectionReference<Map<String, dynamic>> orders =
      FirebaseFirestore.instance.collection(CollectionNames.orders);

  static CollectionReference<Map<String, dynamic>> chats =
      FirebaseFirestore.instance.collection(CollectionNames.chats);

  static CollectionReference<Map<String, dynamic>> categories =
      FirebaseFirestore.instance.collection(CollectionNames.categories);
}
