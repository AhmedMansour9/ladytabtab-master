import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';
import '../../../models/collection/app_collections.dart';
import '../../../models/user/user_model.dart';

import '../../../models/cart/cart_model.dart';
import '../../../view_models/user/orders_services.dart';
import '../confirmation/order_transaction.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({
    Key? key,
    required this.cityName,
    required this.userNote,
    required this.paymentVfCash,
  }) : super(key: key);
  final String cityName;
  final String userNote;
  final bool paymentVfCash;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int qty = 1;
  double? fees = 0.0;
  double priceWithoutDelivery = 0.0;
  double priceWithDelivery = 0.0;

  Map<String, dynamic> userData = {};

  late Future<QuerySnapshot<Map<String, dynamic>>>? _cartStream;

  getCurrentUserData() async {
    var result = await AppCollections.users
        .where('uid', isEqualTo: currentUserUid)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        var userModel = UserModel.fromRecipt(doc.data());

        userData = userModel.toRecipt();
      }
    });
    return result;
  }

  Future<void> getFees() async {
    await AppCollections.deliveryFees
        .where('cityName', isEqualTo: widget.cityName)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            fees = value.docs.first.data()['deliveryfee'] + 0.0;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFees();
    getCurrentUserData();

    _cartStream =
        AppCollections.cart.where("userId", isEqualTo: currentUserUid).get();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Map<String, dynamic>> cartProductsList = [];
    double totalAmountWithDelivery = 0.0;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          getTranslatedData(context, "receiptDetails"),
        ),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            primary: Palette.greyColor,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            minimumSize: size,
            maximumSize: size,
          ),
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
            // size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          // stream: null,
          future: _cartStream,
          builder: (context, snapshot) {
            debugPrint("## Streams - Reciept Screen ##");
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              var totalPrice = [];

              List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                  snapshot.data!.docs;
              cartProductsList = [];
              List<CartModel> cartDataList = [];
              for (var doc in snapshot.data!.docs) {
                cartDataList.add(CartModel.fromJson(doc.data()));
              }
              List<double> totalAmount = [];

              for (var doc in docs) {
                double amount = doc.get('totalPrice');
                totalAmount.add(amount);
              }
              double total = totalAmount.fold(
                (0),
                (previousAmount, currenAmount) => previousAmount + currenAmount,
              );
              totalAmountWithDelivery = total + (fees ?? 40.0);
              return Column(
                children: [
                  Expanded(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (notification) {
                        notification.disallowIndicator();
                        return true;
                      },
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        children: snapshot.data!.docs.map((doc) {
                          totalPrice.add(doc['totalPrice']);
                          num value = totalPrice.fold(
                            (0),
                            (value, element) => value + element,
                          );
                          priceWithoutDelivery = value + 0.0;
                          priceWithDelivery = priceWithoutDelivery + fees!;
                          if (cartProductsList.contains(doc.data()) == false) {
                            cartProductsList.add(doc.data());
                          }
                          qty = doc.get('qty');

                          CartModel cartModel = CartModel.fromJson(doc.data());
                          return ReceiptCard(
                            title: cartModel.prodName.toString(),
                            subtitle: cartModel.prodDetails.toString(),
                            price: cartModel.prodPrice!.toDouble(),
                            discount: cartModel.prodPrice!.toDouble(),
                            prodPriceWithDiscount:
                                cartModel.itemPriceWithDiscount!.toDouble(),
                            productId: cartModel.productId!,
                            cartQty: cartModel.qty!,
                            cartItemId: cartModel.cartItemId!,
                            imageUrl: cartModel.itemImgUrl ?? "",
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Total price & checkout button
                  Container(
                    // height: 230,
                    decoration: const BoxDecoration(
                      // color: Color(0xFF151414),
                      color: Color.fromARGB(255, 255, 255, 255),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.black12,
                      //     blurRadius: 23,
                      //   )
                      // ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      // border: Border(
                      //   top: BorderSide(
                      //     color: Color.fromARGB(255, 224, 224, 224),
                      //     width: 0.5,
                      //   ),
                      // ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                '${getTranslatedData(context, "itemsCount")} (${docs.length})',
                                style: textTheme.subtitle2!.copyWith(
                                  color: Palette.blackColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${priceWithoutDelivery.toStringAsFixed(2)} ${getTranslatedData(context, "egyPrice")}',
                                style: textTheme.subtitle2!.copyWith(
                                  color: Palette.blackColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 11),
                          Row(
                            children: [
                              Text(
                                getTranslatedData(context, "deliveryFees"),
                                style: textTheme.subtitle2!.copyWith(
                                  color: Palette.blackColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$fees ${getTranslatedData(context, "egyPrice")}',
                                style: textTheme.subtitle2!.copyWith(
                                  color: Palette.blackColor,
                                ),
                              ),
                            ],
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 10.0),
                          //   child: DashedLineConnector(
                          //     color: Palette.greyColor,
                          //     direction: Axis.horizontal,
                          //     thickness: 0.5,
                          //     dash: 7,
                          //     gap: 7,
                          //   ),
                          // ),
                          const Divider(),
                          Row(
                            children: [
                              Text(
                                getTranslatedData(
                                  context,
                                  "totalPaymentRequired",
                                ),
                                style: textTheme.subtitle1!.copyWith(
                                  color: Palette.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              _OrderFees(priceWithDelivery: priceWithDelivery),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.90,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                UserOrdersServices userOrders =
                                    UserOrdersServices();
                                // Add cart items
                                Random random = Random();
                                Random random2 = Random();
                                Random random3 = Random();
                                int orderId =
                                    random.nextInt(100) * random2.nextInt(100) +
                                        random3.nextInt(100);
                                // TODO: ORDER NUMBER
                                String uniqueOrderId =
                                    ((orderId * 99) * 9).toString();
                                userOrders
                                    .addDataToOrder(
                                  productsList: cartProductsList,
                                  orderDate: Timestamp.fromDate(DateTime.now()),
                                  orderId: uniqueOrderId,
                                  orderStatus: "pending",
                                  totalAmount: totalAmountWithDelivery,
                                  isVfCashPayment: widget.paymentVfCash,
                                  userNote: widget.userNote,
                                  userData: userData,
                                  deliveryFees: fees!,
                                )
                                    .then((value) async {
                                  for (var product in cartProductsList) {
                                    AppCollections.products
                                        .doc(product['productId'])
                                        .update({
                                      'prodAvailableQty':
                                          FieldValue.increment(-product['qty']),
                                    });
                                  }
                                  // TODO: update payment method
                                  // TODO: Increase qty from all product in the orders
                                  if (widget.paymentVfCash == true) {
                                    WidgetsBinding.instance
                                       ?.addPostFrameCallback((_) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const _VFCashInfoScreen(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    });
                                  } else {
                                    WidgetsBinding.instance
                                        ?.addPostFrameCallback((_) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const OrderTransaction(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    });
                                  }
                                  //                           // },
                                }).catchError((error) {});
                              },
                              child: Text(
                                getTranslatedData(context, "orderNow")
                                    .toUpperCase(),
                                style: textTheme.subtitle2!.copyWith(
                                  color: Palette.bgColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      kEmptyCartIcon,
                      width: 150,
                      // color: Palette.greyColor,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      getTranslatedData(context, "emptyCart"),
                      textAlign: TextAlign.center,
                      style: textTheme.subtitle1!.copyWith(
                        color: Palette.greyColor,
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

class _OrderFees extends StatelessWidget {
  const _OrderFees({
    Key? key,
    required this.priceWithDelivery,
  }) : super(key: key);

  final double priceWithDelivery;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      "${priceWithDelivery.toStringAsFixed(2)} ${getTranslatedData(context, "egyPrice")}",
      style: textTheme.subtitle1!.copyWith(
        color: Palette.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ReceiptCard extends StatefulWidget {
  const ReceiptCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.discount,
    required this.prodPriceWithDiscount,
    required this.productId,
    required this.cartQty,
    required this.cartItemId,
    required this.imageUrl,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double price;
  final double discount;
  final double? prodPriceWithDiscount;
  final String productId;
  final String cartItemId;
  final int cartQty;
  final String imageUrl;

  @override
  State<ReceiptCard> createState() => _CustomCartCardState();
}

class _CustomCartCardState extends State<ReceiptCard> {
  late double prodPrice;
  @override
  void initState() {
    super.initState();
    prodPrice = widget.prodPriceWithDiscount == 0 ||
            widget.prodPriceWithDiscount != null
        ? widget.price
        : widget.prodPriceWithDiscount!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 90,
                    height: 90,
                    // padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      // color: Color(0xFFF6F6F7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(7),
                      ),
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: widget.imageUrl.isEmpty
                        ? Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              kLogoIcon,
                              width: 35,
                              height: 35,
                              color: Palette.greyColor,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(7),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              fit: BoxFit.cover,
                              width: 42,
                              // placeholder: (context, url) {
                              //   return const CustomProgressIndicator();
                              // },
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 10),
                // Item content
                Expanded(
                  flex: 3,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.title.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            // overflow: TextOverflow.ellipsis,
                            ),
                      ),
                      widget.subtitle.isEmpty
                          ? const SizedBox()
                          : const SizedBox(height: 5),
                      widget.subtitle.isEmpty
                          ? const SizedBox()
                          : Text(
                              widget.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                      const SizedBox(height: 5),
                      Text(
                        '$prodPrice ${getTranslatedData(context, "egyPrice")}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text('${widget.cartQty}x'),
        ],
      ),
    );
  }
}

class _VFCashInfoScreen extends StatelessWidget {
  const _VFCashInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String paymentThroughVFCash =
        'لمواصلة عملية الدفع من خلال "فودافون كاش"، برجاء التحدث إلينا عبر الشات داخل تطبيق ليدي طبطب.';
    String vfCashNumber = "رقم خدمة فودافون كاش";
    String number = "01011121156";
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F1),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: ScreenSize.screenWidth! * 0.90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        paymentThroughVFCash,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "$vfCashNumber: $number",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  // height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderTransaction(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'تم',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Palette.bgColor,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
