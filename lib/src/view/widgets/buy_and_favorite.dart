import '../../../exports_main.dart';
import '../../models/collection/app_collections.dart';
import '../components/shared/get_translated_data.dart';
import '../components/shared/screens_size.dart';
import 'checkout_modal_dialog.dart';
import 'login_button.dart';

class BuyFavoriteButtons extends StatefulWidget {
  const BuyFavoriteButtons({
    Key? key,
    required this.productModel,
    required this.selectedIndexColor,
    required this.selectedSmells,
  }) : super(key: key);

  final ProductModel productModel;
  final int? selectedIndexColor;
  final String? selectedSmells;

  @override
  State<BuyFavoriteButtons> createState() => _BuyFavoriteButtonsState();
}

class _BuyFavoriteButtonsState extends State<BuyFavoriteButtons> {
  final currentUser = FirebaseAuth.instance.currentUser;

  ProductServices productServices = ProductServices();
  CartServices cartServices = CartServices();

  late Stream<QuerySnapshot<Map<String, dynamic>>> _favoriteStream;

  @override
  void initState() {
    super.initState();

    _favoriteStream = AppCollections.cart
        .where("userId", isEqualTo: currentUser!.uid)
        .where("productId", isEqualTo: widget.productModel.prodUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return currentUser == null
        ? const LoginButton()
        : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _favoriteStream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.docs.isNotEmpty &&
                  snapshot.data!.docs.first.get("qty") > 0) {
                int length = snapshot.data!.docs.first.get('qty') ?? 0;

                return GestureDetector(
                  // elevation: 0.0,
                  // focusElevation: 0.0,
                  // highlightElevation: 0.0,
                  // fillColor: Palette.primaryColor,

                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: ScreenSize.screenHeight! * 0.42,
                        // minHeight: MediaQuery.of(context).size.height * 0.34,
                      ),
                      builder: (context) {
                        return CheckOutDialog(
                          productId: widget.productModel.prodUid!,
                          totalPrice: (widget
                                          .productModel.prodPriceWithDiscount ==
                                      0.0 ||
                                  widget.productModel.prodPriceWithDiscount ==
                                      null)
                              ? widget.productModel.prodPrice!
                              : widget.productModel.prodPriceWithDiscount!,
                        );
                      },
                    );
                  },

                  child: Center(
                    child: Container(
                      width: ScreenSize.screenWidth! * 0.70,
                      height: 45,
                      decoration: const BoxDecoration(
                        borderRadius: Radiuz.largeRadius,
                        color: Palette.primaryColor,
                        // gradient: LinearGradient(
                        //   colors: [
                        //   ],
                        // ),
                      ),
                      child: Stack(
                        children: [
                          // const SizedBox(width: 28),
                          Center(
                            child: Text(
                              getTranslatedData(context, "increaseQty"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: Palette.bgColor,
                                  ),
                            ),
                          ),
                          Positioned(
                            right: 7.0,
                            top: 0,
                            bottom: 0,
                            child: _CartProductsCounter(currentIndex: length),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (widget.productModel.prodAvailableQty! <= 0) {
                return Center(
                  child: SizedBox(
                    width: ScreenSize.screenWidth! * 0.70,
                    height: 45,
                    child: RawMaterialButton(
                      onPressed: null,
                      elevation: 0.0,
                      focusElevation: 0.0,
                      highlightElevation: 0.0,
                      fillColor: const Color.fromARGB(25, 248, 101, 38),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        "OUT OF STOCK",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: SizedBox(
                    width: ScreenSize.screenWidth! * 0.70,
                    height: 45,
                    child: RawMaterialButton(
                      elevation: 0.0,
                      focusElevation: 0.0,
                      highlightElevation: 0.0,
                      fillColor: Palette.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: Radiuz.largeRadius,
                      ),
                      onPressed: () async {
                        productServices
                            .getAvailableItemById(widget.productModel.prodUid!);

                        // TODO: NO COLOR & NO SMELL
                        if ((widget.productModel.prodColors == null ||
                                widget.productModel.prodColors!.isEmpty) &&
                            (widget.productModel.prodSmells == null ||
                                widget.productModel.prodSmells!.isEmpty) &&
                            widget.productModel.prodAvailableQty! > 0) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                            msg:
                                "${widget.productModel.prodName} ${getTranslatedData(context, "product_add_to_cart")}",
                          );
                          await cartServices.addItemToCart(
                            qty: 1,
                            itemId: widget.productModel.prodUid,
                            prodCategory: widget.productModel.prodCategory,
                            prodName: widget.productModel.prodName,
                            prodDetails: widget.productModel.prodDetails,
                            prodPrice: (widget.productModel
                                            .prodPriceWithDiscount ==
                                        0.0 ||
                                    widget.productModel.prodPriceWithDiscount ==
                                        null)
                                ? widget.productModel.prodPrice
                                : widget.productModel.prodPriceWithDiscount,
                            prodImgUrl: widget.productModel.prodImgUrl,
                            itemQty: widget.productModel.prodAvailableQty,
                            isAvailable: widget.productModel.prodIsAvailable,
                            selectedColorIndex: null,
                            smellName: null,
                          );
                        } else

                        // TODO: NO COLOR & YES SMELL
                        if ((widget.productModel.prodColors == null ||
                                widget.productModel.prodColors!.isEmpty) &&
                            widget.productModel.prodSmells != null &&
                            widget.selectedSmells != null &&
                            widget.productModel.prodAvailableQty! > 0) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                            msg:
                                "${widget.productModel.prodName} added to cart",
                          );
                          await cartServices.addItemToCart(
                            qty: 1,
                            itemId: widget.productModel.prodUid,
                            prodCategory: widget.productModel.prodCategory,
                            prodName: widget.productModel.prodName,
                            prodDetails: widget.productModel.prodDetails,
                            prodPrice: (widget.productModel
                                            .prodPriceWithDiscount ==
                                        0.0 ||
                                    widget.productModel.prodPriceWithDiscount ==
                                        null)
                                ? widget.productModel.prodPrice
                                : widget.productModel.prodPriceWithDiscount,
                            prodImgUrl: widget.productModel.prodImgUrl,
                            itemQty: widget.productModel.prodAvailableQty,
                            isAvailable: widget.productModel.prodIsAvailable,
                            selectedColorIndex: null,
                            smellName: widget.selectedSmells,
                          );
                        } else

                        // TODO: YES COLOR & NO SMELL
                        if (widget.productModel.prodColors != null &&
                            widget.selectedIndexColor != null &&
                            (widget.productModel.prodSmells == null ||
                                widget.productModel.prodSmells!.isEmpty) &&
                            widget.productModel.prodAvailableQty! > 0) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                            msg:
                                "${widget.productModel.prodName} added to cart",
                          );
                          await cartServices.addItemToCart(
                            qty: 1,
                            itemId: widget.productModel.prodUid,
                            prodCategory: widget.productModel.prodCategory,
                            prodName: widget.productModel.prodName,
                            prodDetails: widget.productModel.prodDetails,
                            prodPrice: (widget.productModel
                                            .prodPriceWithDiscount ==
                                        0.0 ||
                                    widget.productModel.prodPriceWithDiscount ==
                                        null)
                                ? widget.productModel.prodPrice
                                : widget.productModel.prodPriceWithDiscount,
                            prodImgUrl: widget.productModel.prodImgUrl,
                            itemQty: widget.productModel.prodAvailableQty,
                            isAvailable: widget.productModel.prodIsAvailable,
                            selectedColorIndex: widget.selectedIndexColor,
                            smellName: null,
                          );
                        } else

                        // TODO: YES COLOR & YES SMELL
                        if (widget.productModel.prodColors != null &&
                            widget.selectedIndexColor != null &&
                            widget.productModel.prodSmells != null &&
                            widget.selectedSmells != null &&
                            widget.productModel.prodAvailableQty! > 0) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                            msg:
                                "${widget.productModel.prodName} added to cart",
                          );
                          await cartServices.addItemToCart(
                            qty: 1,
                            itemId: widget.productModel.prodUid,
                            prodCategory: widget.productModel.prodCategory,
                            prodName: widget.productModel.prodName,
                            prodDetails: widget.productModel.prodDetails,
                            prodPrice: (widget.productModel
                                            .prodPriceWithDiscount ==
                                        0.0 ||
                                    widget.productModel.prodPriceWithDiscount ==
                                        null)
                                ? widget.productModel.prodPrice
                                : widget.productModel.prodPriceWithDiscount,
                            prodImgUrl: widget.productModel.prodImgUrl,
                            itemQty: widget.productModel.prodAvailableQty,
                            isAvailable: widget.productModel.prodIsAvailable,
                            selectedColorIndex: widget.selectedIndexColor,
                            smellName: widget.selectedSmells,
                          );
                        } else {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                            msg: "Please, select a color & a smell",
                          );
                        }
                        // End
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            getTranslatedData(context, "buyNow").toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
  }
}

class _CartProductsCounter extends StatelessWidget {
  const _CartProductsCounter({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 35,
      height: 35,
      // margin: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Color.fromARGB(50, 0, 0, 0),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          currentIndex.toString(),
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
        ),
      ),
    );
  }
}
