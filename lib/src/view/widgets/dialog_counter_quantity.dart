import '../../../exports_main.dart';
import 'custom_progress_dialog.dart';

class DialogCounterQuantity extends StatefulWidget {
  const DialogCounterQuantity({
    Key? key,
    required this.productId,
    required this.cartQty,
    required this.cartItemId,
    this.isProductDetailsModal = false,
  }) : super(key: key);

  final String productId;
  final String cartItemId;
  final int cartQty;
  final bool isProductDetailsModal;

  @override
  State<DialogCounterQuantity> createState() => _DialogCounterQuantityState();
}

class _DialogCounterQuantityState extends State<DialogCounterQuantity> {
  final ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 103,
      // height: 30,
      padding: const EdgeInsets.all(7),
      // alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: RawMaterialButton(
              fillColor: const Color.fromARGB(255, 237, 240, 243),
              elevation: 0.0,
              highlightElevation: 0.0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(7),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                // side: BorderSide(
                //   width: 1.0,
                //   color: Palette.primaryColor,
                // ),
              ),
              onPressed: () async {
                CartServices cartServices = CartServices();

                if (widget.cartQty == 1 || widget.cartQty == 0) {
                } else {
                  buildCustomShowDialog(context);
                }
                if (widget.cartQty > 1) {
                  cartServices
                      .updateQtyAndPrice(
                    productId: widget.productId,
                    qty: widget.cartQty - 1,
                    isIncrease: false,
                  )
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                } else if (widget.cartQty == 1 || widget.cartQty == 0) {
                  cartServices.deleteCartProductById(
                    cartItemId: widget.cartItemId,
                    productId: widget.productId,
                  );
                  // TODO: if this is product details show modal navigator.pop if else no
                  // Navigator.of(context).pop();
                }
              },
              child: widget.cartQty == 1 || widget.cartQty == 0
                  ? const Icon(
                      Icons.delete,
                      size: 15,
                      color: Color.fromARGB(255, 77, 77, 77),
                    )
                  : const Icon(
                      Icons.remove,
                      size: 15,
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
            ),
          ),
          // QTY
          SizedBox(
            width: 50,
            child: Text(
              widget.cartQty.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: RawMaterialButton(
              fillColor: const Color.fromARGB(177, 42, 172, 70),
              elevation: 0.0,
              highlightElevation: 0.0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(7),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onPressed: () async {
                try {
                  buildCustomShowDialog(context);
                  int currentProdQty = await _productServices
                      .getAvailableItemById(widget.productId);

                  if (widget.cartQty == currentProdQty || currentProdQty == 0) {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(
                      msg:
                          "لا يمكن إضافة اكثر من $currentProdQty، الكمية محدودة",
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  }
                  CartServices cartServices = CartServices();
                  int qty = widget.cartQty;
                  if (widget.cartQty > 0 &&
                      widget.cartQty < currentProdQty &&
                      currentProdQty > 0) {
                    cartServices
                        .updateQtyAndPrice(
                      productId: widget.productId,
                      qty: ++qty,
                      // qty: currentProdQty++,
                      isIncrease: true,
                    )
                        .then((value) async {
                      Navigator.of(context).pop();
                    });
                  }
                } catch (error) {
                  printDebugMode("Failed");
                }
              },
              child: const Icon(
                Icons.add,
                size: 15,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
