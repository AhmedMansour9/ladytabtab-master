import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ladytabtab/src/models/collection/app_collections.dart';

import '../../../constants/routes/routes.dart';
import '../../../models/cart/cart_model.dart';
import '../../components/custom_progress_indicator.dart';
import '../../theme/palette.dart';
import '../../components/radiuz.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import '../shipping/address_screen.dart';
import 'custom_cart_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key, this.isFromProductDetails = false})
      : super(key: key);

  final bool isFromProductDetails;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // List<double> totalItemsPrice = [];
  // num getTotalPrice = 0.0;
  // double getTotalDiscount = 0.0;
  // double getTotalPayment = 0.0;

  // Test
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  int qty = 1;
  double priceWithoutDelivery = 0.0;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _cartStream;

  @override
  void initState() {
    super.initState();
    _cartStream = AppCollections.cart
        .where("userId", isEqualTo: currentUserUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(getTranslatedData(context, "shopping_cart_title")),
        leading: TextButton(
          onPressed: () {
            if (widget.isFromProductDetails) {
              Navigator.of(context).pop();
            }
            Navigator.pop(context);
          },
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
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          // stream: null,
          stream: _cartStream,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              debugPrint("## Streams - Cart Screen ##");
              var totalPrice = [];
              List<CartModel> cartDataList = [];
              for (var doc in snapshot.data!.docs) {
                cartDataList.add(CartModel.fromJson(doc.data()));
              }
              var docs = snapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return false;
                      },
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        children: snapshot.data!.docs.map((doc) {
                          // final num totalPrice = doc.data()['totalPrice'];
                          totalPrice.add(doc['totalPrice']);
                          //
                          num value = totalPrice.fold(
                            (0),
                            (value, element) => value + element,
                          );
                          priceWithoutDelivery = value + 0.0;
                          qty = doc.get('qty');

                          CartModel cartModel = CartModel.fromJson(doc.data());
                          return CustomCartCard(
                            title: cartModel.prodName.toString(),
                            subtitle: cartModel.prodDetails.toString(),
                            price: cartModel.prodPrice!.toDouble(),
                            // discount: cartModel.itemPriceWithDiscount!.toDouble(),
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
                      gradient: LinearGradient(
                        colors: [
                          // Color.fromARGB(255, 242, 233, 226),
                          // Color(0xFFfdfcfb),

                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 255, 255, 255),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 216, 216, 216),
                          blurRadius: 23,
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                getTranslatedData(context, "itemsCount"),
                                style: theme.textTheme.subtitle1!.copyWith(
                                  color: Palette.blackColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${docs.length}',
                                style: theme.textTheme.subtitle1!.copyWith(
                                  color: const Color.fromARGB(255, 234, 81, 76),
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
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                getTranslatedData(
                                  context,
                                  "totalPaymentRequired",
                                ),
                                style: theme.textTheme.subtitle1!.copyWith(
                                  color: Palette.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${priceWithoutDelivery.toStringAsFixed(2)} ${getTranslatedData(context, "egyPrice")}',
                                style: theme.textTheme.subtitle1!.copyWith(
                                  color: const Color.fromARGB(255, 234, 81, 76),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const _AddMoreContinueButtons(),
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
                      style: theme.textTheme.subtitle2!.copyWith(
                        color: Palette.greyColor,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Palette.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        shadowColor: Palette.elevationColor,
                        primary: Colors.blueGrey,
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesPaths.mainScreens,
                          (route) => false,
                        );
                      },
                      child: Text(
                        getTranslatedData(context, "backToHome"),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                        ),
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

class _AddMoreContinueButtons extends StatelessWidget {
  const _AddMoreContinueButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(
                      MaterialState.pressed,
                    )) {
                      return Colors.white;
                    }
                    return Palette.blueColor;
                  },
                ),
                textStyle: MaterialStateProperty.resolveWith((states) {
                  return Theme.of(context).textTheme.subtitle2;
                }),
                shape:
                    MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                        (Set<MaterialState> status) {
                  if (status.contains(MaterialState.pressed)) {
                    return const RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: Radiuz.largeRadius,
                    );
                  }
                  return const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Palette.blueColor,
                      width: 1.0,
                    ),
                    borderRadius: Radiuz.largeRadius,
                  );
                }),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(
                      MaterialState.pressed,
                    )) {
                      // return Palette.primaryColor;
                      return Palette.blueColor;
                    }
                    return Colors.white;
                  },
                ),
              ),
              child: Text(
                getTranslatedData(context, "addMore"),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesPaths.mainScreens,
                  (route) => false,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AddressScreen.route,
                  arguments: true,
                );
              },
              child: Text(
                getTranslatedData(context, "checkout").toUpperCase(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
