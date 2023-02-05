import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../models/cart/cart_model.dart';
import '../../../models/collection/app_collections.dart';
import '../../../models/order/order_model.dart';
import '../../components/custom_arrow_back.dart';
import '../../components/custom_progress_indicator.dart';
import '../../theme/palette.dart';
import '../../components/shared/get_translated_data.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const route = 'orderScreen';

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  // String orderStatus = '';
  OrderStatus orderStatus = OrderStatus.pending;
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _ordersStream;

  @override
  void initState() {
    super.initState();

    _ordersStream = AppCollections.orders
        .where('currentUserId', isEqualTo: currentUserUid)
        .orderBy('orderDate', descending: true)
        .snapshots();
  }

  Future<OrderStatus> checkOrderStatus(String status) async {
    switch (status) {
      case "pending":
        return OrderStatus.pending;
      case "preparing":
        return OrderStatus.preparing;
      case "shipped":
        return OrderStatus.shipped;
      case "delivered":
        return OrderStatus.delivered;
      case "returned":
        return OrderStatus.returned;
      case "canceled":
        return OrderStatus.canceledByAdmin;
      case "canceledByCustomer":
        return OrderStatus.canceledByCustomer;
      default:
        return OrderStatus.pending;
    }
  }

  bool isEx = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(
        title: Text(
          getTranslatedData(context, "myOrders"),
        ),
        leading: CustomArrowBack(ctx: context),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _ordersStream,
          builder: (context, snapshot) {
            debugPrint("## Streams - Orders Screen ##");
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: snapshot.data!.docs.length,
                // separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  OrderModel userOrders = OrderModel.toJson(
                    snapshot.data!.docs[index].data(),
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5,
                    ),
                    child: Card(
                      // color: const Color(0xFFF5F5ED),
                      color: const Color.fromARGB(255, 254, 254, 254),

                      elevation: 0.0,
                      // elevation: 3.30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color.fromARGB(120, 222, 222, 222),
                          width: 2.0,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        // highlightColor: Colors.blue.shade100.withOpacity(0.3),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            OrderDetails.route,
                            arguments: userOrders,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),
                            // Payment method
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                userOrders.isVfCashPayment == true
                                    ? Text(
                                        'الدفع: فودافون كاش',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      )
                                    : Text(
                                        'الدفع: عند الإستلام',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                Text(
                                  'تاريخ الطلب ${formats(userOrders.orderDate!)}',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: const Color(0xFF414141),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Order total price & ordering date
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      'الإجمالي ${userOrders.orderTotalAmount!.toStringAsFixed(2)}',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                            color: const Color(0xFF414141),
                                          ),
                                    ),
                                  ],
                                ),

                                // Order status & order number
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      'رقم الطلب ${userOrders.orderId}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                            color: const Color(0xFF414141),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            const Divider(
                              color: Color.fromARGB(255, 255, 255, 255),
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 23,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        46,
                                        179,
                                        57,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          255,
                                          192,
                                          246,
                                          200,
                                        ),
                                        width: 5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  FutureBuilder<OrderStatus>(
                                    future: checkOrderStatus(
                                      userOrders.orderStatus!,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        switch (snapshot.data) {
                                          case OrderStatus.pending:
                                            return const Text(
                                              "تم إستقبال طلبك",
                                            );
                                          case OrderStatus.preparing:
                                            return const Text("تم قبول طلبك");
                                          case OrderStatus.shipped:
                                            return const Text("تم شحن طلبك");
                                          case OrderStatus.delivered:
                                            return const Text("تم التوصيل");
                                          case OrderStatus.returned:
                                            return const Text("تم إرجاعها");
                                          case OrderStatus.canceledByAdmin:
                                            return const Text("تم رفض الطلب");
                                          case OrderStatus.canceledByCustomer:
                                            return const Text("تم إلغاء طلبك");
                                          default:
                                            return const Text(
                                              "تم إستقبال طلبك",
                                            );
                                        }
                                      }
                                      return const CustomProgressIndicator();
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Text(
                            //   orderStatus,
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .subtitle2!
                            //       .copyWith(
                            //         color: Colors.black,
                            //         overflow: TextOverflow.ellipsis,
                            //         // fontWeight: FontWeight.bold,
                            //       ),
                            // ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isEmpty) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslatedData(context, "noOrders"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Palette.greyColor,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      getTranslatedData(context, "orderAndEnjoy"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.black54,
                            height: 1.7,
                          ),
                    ),
                  ],
                ),
              );
            }

            return const CustomProgressIndicator();
          },
        ),
      ),
    );
  }
}

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key, required this.userOrdersModel})
      : super(key: key);
  final OrderModel userOrdersModel;
  static const route = '/orderDetails';

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String formats(Timestamp timeStamp) {
    var myDate = DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return intl.DateFormat('yyy/MM/dd').format(myDate);
  }

  late bool isPassDay;

  checkDate() {
    Timestamp todayTimestamp = Timestamp.fromDate(DateTime.now());
    DateTime todayDate =
        DateTime.fromMillisecondsSinceEpoch(todayTimestamp.seconds * 1000);
    DateTime orderDate = DateTime.fromMillisecondsSinceEpoch(
      widget.userOrdersModel.orderDate!.seconds * 1000,
    );
    final int differences = todayDate.difference(orderDate).inDays;
    if (differences >= 1) {
      isPassDay = true;
    } else if (differences == 0) {
      isPassDay = false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkDate();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Palette.mainBgColor,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'تفاصيل الطلب',
          // style: Theme.of(context).textTheme.subtitle2,
        ),
        leading: MaterialButton(
          height: 40.0,
          minWidth: 40.0,
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // color: Colors.grey.shade200,
          elevation: 0.0,
          highlightElevation: 0.0,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          // constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Color.fromARGB(255, 110, 110, 110),
            size: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Order Details
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowIndicator();
                return true;
              },
              child: Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'تاريخ الطلب',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(width: 7.0),
                            Text(
                              formats(widget.userOrdersModel.orderDate!),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),

                        // TOTAL REQUIRED

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'المجموع الكلي',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(width: 7.0),
                            Text(
                              '${widget.userOrdersModel.orderTotalAmount} ج.م',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        itemCount: widget.userOrdersModel.orderProducts!.length,
                        itemBuilder: (context, index) {
                          final product =
                              widget.userOrdersModel.orderProducts![index];

                          CartModel cartData = CartModel.fromJson(product);
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              // vertical: 10,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                // vertical: 5.0,
                                horizontal: 14.0,
                              ),
                              title: Text(
                                '${cartData.prodName}',
                                style: theme.textTheme.subtitle2!.copyWith(
                                  color: Palette.secondaryColor,
                                ),
                              ),
                              subtitle: Text(
                                'الكمية ${cartData.qty}',
                                style: theme.textTheme.subtitle2!.copyWith(
                                  color:
                                      const Color.fromARGB(255, 110, 110, 110),
                                ),
                              ),
                              trailing: Text(
                                '${cartData.totalPrice} ج.م',
                                style: theme.textTheme.subtitle2!.copyWith(
                                  color: Palette.secondaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cancel the order
            CancelOrderButton(
              orderDocId: widget.userOrdersModel.orderDocId!,
              orderNumber: widget.userOrdersModel.orderId!,
              orderStatus: widget.userOrdersModel.orderStatus!,
              orderPassedDay: isPassDay,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CancelOrderButton extends StatefulWidget {
  const CancelOrderButton({
    Key? key,
    required this.orderDocId,
    required this.orderNumber,
    required this.orderStatus,
    required this.orderPassedDay,
  }) : super(key: key);

  final String orderDocId;
  final String orderNumber;
  final String orderStatus;
  final bool orderPassedDay;

  @override
  State<CancelOrderButton> createState() => _CancelOrderButtonState();
}

class _CancelOrderButtonState extends State<CancelOrderButton> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _ordersByIdStream;

  @override
  void initState() {
    super.initState();
    _ordersByIdStream =
        AppCollections.orders.doc(widget.orderDocId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _ordersByIdStream,
      builder: (context, snapshot) {
        debugPrint("## Streams - Cancel order btn ##");
        if (!snapshot.hasData && snapshot.data == null) {
          return const SizedBox();
        }
        switch (snapshot.data!['orderStatus']) {
          case "pending":
          case "preparing":
          case "shipped":
            if (widget.orderPassedDay == false) {
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 7,
                      ),
                      primary: Palette.primaryColor,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'إلغاء الطلب',
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              'هل تريد إلغاء الطلب رقم ${widget.orderNumber}؟',
                              style: theme.textTheme.subtitle2,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  //TODO: update or status
                                  //TODO: update each product which selected in this order
                                  //TODO: UPATE QTY FOR EACH PRODUCT IN THIS ORDER
                                  AppCollections.orders
                                      .doc(widget.orderDocId)
                                      .get()
                                      .then((value) async {
                                    String currentStatus =
                                        value.get('orderStatus');
                                    switch (currentStatus) {
                                      case "pending":
                                      case "preparing":
                                        await AppCollections.orders
                                            .doc(widget.orderDocId)
                                            .update({
                                          "orderStatus": "canceledByCustomer"
                                        }).then((value) {
                                          Navigator.pop(context);
                                        });
                                        break;
                                      case "shipped":
                                        await AppCollections.orders
                                            .doc(widget.orderDocId)
                                            .update({
                                          "orderStatus": "returned"
                                        }).then((value) {
                                          Navigator.pop(context);
                                        });
                                        break;
                                    }
                                    List<dynamic> products = [];
                                    // GET ORDERS - PRODUCST IDs
                                    await AppCollections.orders
                                        .doc(widget.orderDocId)
                                        .get()
                                        .then((value) async {
                                      products = value.get("orderProducts");
                                      products = value.get("orderProducts");
                                      for (var product in products) {
                                        await AppCollections.products
                                            .doc(product['productId'])
                                            .update({
                                          "prodAvailableQty":
                                              FieldValue.increment(
                                            product['qty'],
                                          )
                                        }).then((value) {});
                                      }
                                    });
                                  });
                                },
                                child: Text(
                                  'نعم',
                                  style: theme.textTheme.subtitle2,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'لا',
                                  style: theme.textTheme.subtitle2,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          // End
          default:
            return const SizedBox();
        }
      },
    );
  }
}
