import 'package:ladytabtab/exports_main.dart';

import '../../models/collection/app_collections.dart';
import '../components/dotted_line.dart';
import '../components/shared/get_translated_data.dart';
import '../screens/cart/cart_screen.dart';
import 'dialog_counter_quantity.dart';

class CheckOutDialog extends StatefulWidget {
  const CheckOutDialog({
    Key? key,
    required this.productId,
    // required this.cartItemId,
    required this.totalPrice,
    // required this.cartQty,
  }) : super(key: key);

  final String productId;
  // final String cartItemId;
  final double totalPrice;
  // final int cartQty;

  @override
  State<CheckOutDialog> createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  double totalPrice = 0.0;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _dialogStream;

  @override
  void initState() {
    super.initState();

    _dialogStream = AppCollections.cart
        .where("userId", isEqualTo: currentUserUid)
        .where("productId", isEqualTo: widget.productId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _dialogStream,
      builder: (context, snapshot) {
        printDebugMode("## Streams - Checkout dialog ##");
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.docs.isNotEmpty) {
          var docs = snapshot.data!.docs;
          var qty = docs.first.get("qty") == 0 ? 1 : docs.first.get("qty");
          totalPrice = qty * widget.totalPrice;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Close icon
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    splashRadius: 20,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        docs.first.data()["prodName"],
                        style: theme.textTheme.subtitle1,
                      ),
                      const SizedBox(height: 10),

                      // Increase & Decrease
                      DialogCounterQuantity(
                        productId: widget.productId,
                        cartQty: docs.first.data()['qty'],
                        cartItemId: docs.first.data()['cartItemId'],
                        isProductDetailsModal: true,
                      ),

                      const SizedBox(height: 14),
                      const DottedLine(
                        dashColor: Color.fromARGB(255, 191, 191, 191),
                      ),
                      const SizedBox(height: 14),

                      // Total amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslatedData(context, "totalPrice"),
                            style: theme.textTheme.subtitle1!
                                .copyWith(color: Palette.blackColor),
                          ),
                          Text(
                            '${totalPrice.toStringAsFixed(2)} ${getTranslatedData(context, "egyPrice")}',
                            style: theme.textTheme.subtitle1!
                                .copyWith(color: Palette.blackColor),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const _CheckOutButton(),

                      const SizedBox(height: 12),
                      // End class
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.docs.isEmpty) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
        }
        return const SizedBox();
      },
    );
  }
}

class _CheckOutButton extends StatelessWidget {
  const _CheckOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.94,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const CartScreen(
          //       isFromProductDetails: true,
          //     ),
          //   ),
          // );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CartScreen(
                isFromProductDetails: true,
              ),
            ),
          );
        },
        child: Text(
          getTranslatedData(context, "checkout").toUpperCase(),
        ),
      ),
    );
  }
}
