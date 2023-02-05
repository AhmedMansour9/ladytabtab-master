import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  preparing,
  shipped,
  delivered,
  returned,
  canceledByAdmin,
  canceledByCustomer,
}

class OrderModel {
  OrderModel({
    this.currentUserId,
    this.orderId,
    this.orderTotalAmount,
    this.orderProducts,
    this.orderDate,
    this.orderStatus,
    this.isVfCashPayment,
    this.userNote,
    this.userData,
    this.deliveryFees,
  });
  String? currentUserId;
  String? orderId;
  double? orderTotalAmount;
  List<dynamic>? orderProducts;
  Timestamp? orderDate;
  String? orderStatus;
  bool? isVfCashPayment;
  String? userNote;
  Map<String, dynamic>? userData;
  double? deliveryFees;
  String? orderDocId;

  // Name constractor
  OrderModel.toJson(Map<String, dynamic> json)
      : currentUserId = json['currentUserId'],
        orderId = json['orderId'],
        orderTotalAmount = json['orderTotalAmount'] + 0.0,
        orderProducts = json['orderProducts'],
        orderDate = json['orderDate'],
        orderStatus = json['orderStatus'],
        isVfCashPayment = json['isVfCashPayment'],
        userNote = json['userNote'],
        userData = json['userData'],
        deliveryFees = json['deliveryFees'],
        orderDocId = json['orderDocId'];

  Map<String, dynamic> toMap({
    required String currentUserId,
    required String orderId,
    required double orderTotalAmount,
    required List<dynamic> orderProducts,
    required Timestamp? orderDate,
    required String orderStatus,
    required bool isVfCashPayment,
    String? userNote,
    required Map<String, dynamic> userData,
    required String orderDocId,
    required double deliveryFees,
  }) =>
      {
        'currentUserId': currentUserId,
        'orderId': orderId,
        'orderTotalAmount': orderTotalAmount,
        'orderProducts': orderProducts,
        'orderDate': orderDate,
        'orderStatus': orderStatus,
        'isVfCashPayment': isVfCashPayment,
        'userNote': userNote,
        'userData': userData,
        'orderDocId': orderDocId,
        'deliveryFees': deliveryFees,
      };
}
