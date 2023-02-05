import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/collection/app_collections.dart';
import '../../models/order/order_model.dart';

class UserOrdersServices {
  User currentUser = FirebaseAuth.instance.currentUser!;

  Future<CollectionReference> addDataToOrder({
    required List<Map<String, dynamic>> productsList,
    required String orderId,
    required double totalAmount,
    required Timestamp orderDate,
    required String orderStatus,
    required bool isVfCashPayment,
    String? userNote,
    required Map<String, dynamic> userData,
    required double deliveryFees,
  }) async {
    OrderModel userOrdersModel = OrderModel();

    // Convert the data to map...
    Map<String, dynamic> data = userOrdersModel.toMap(
      currentUserId: currentUser.uid,
      orderId: orderId,
      orderTotalAmount: totalAmount,
      orderProducts: productsList,
      orderDate: orderDate,
      orderStatus: orderStatus,
      isVfCashPayment: isVfCashPayment,
      userNote: userNote,
      userData: userData,
      orderDocId: '',
      deliveryFees: deliveryFees,
    );

    // Add the data to "Orders" collection...
    AppCollections.orders.add(data).then((value) async {
      if (value.id.isNotEmpty) {
        await value.update({'orderDocId': value.id});
      }
    });
    return AppCollections.orders;
  }

  getUserOrders() async {
    await AppCollections.orders.get().then((data) {
      if (data.docs.isNotEmpty) {}
    });
  }

  // get order status by order doc id
  Future<bool> vodafoneCashPayment() async {
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    late bool willBuyByVfCash;

    await AppCollections.orders
        .where("currentUserId", isEqualTo: currentUserUid)
        .orderBy("orderDate")
        .get()
        .then((value) {
      if (value.docs.last.get('orderStatus') == "userCanceledAfterShipped") {
        willBuyByVfCash = true;
      } else {
        willBuyByVfCash = false;
      }
    });
    return willBuyByVfCash;
  }
}
