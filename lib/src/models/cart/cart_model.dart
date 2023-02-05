class CartModel {
  CartModel({
    required this.qty,
    required this.cartItemId,
    required this.prodCategory,
    required this.productId,
    required this.prodName,
    required this.prodDetails,
    required this.prodPrice,
    required this.itemImgUrl,
    required this.prodIsAvailable,
    required this.totalPrice,
    this.userId,
    required this.selectedColorIndex,
    required this.smellName,
  });

  // Fields
  int? qty;
  String? cartItemId;
  String? prodCategory;
  String? productId;
  String? prodName;
  String? prodDetails;
  double? prodPrice;
  String? itemImgUrl;
  bool? prodIsAvailable;
  double? totalPrice;
  double? itemPriceWithDiscount;
  String? userId;
  int? selectedColorIndex;
  String? smellName;

  // From Json
  CartModel.fromJson(Map<String, dynamic> data) {
    qty = data['qty'];
    cartItemId = data['cartItemId'];
    productId = data['productId'];
    prodCategory = data['prodCategory'];
    prodName = data['prodName'];
    prodDetails = data['prodDetails'];
    prodPrice = data['prodPrice'] + 0.0 ?? 0.0;
    itemPriceWithDiscount = data['itemPriceWithDiscount'] != null
        ? data['itemPriceWithDiscount'] + 0.0
        : 0.0;
    itemImgUrl = data['itemImgUrl'];
    totalPrice = data['totalPrice'] + 0.0 ?? 0.0;
    userId = data['userId'];
    selectedColorIndex = data['selectedColorIndex'];
    smellName = data['smellName'];
  }

  // Convert To Map
  Map<String, dynamic> toMap() {
    return {
      'qty': qty,
      'cartItemId': cartItemId,
      'prodCategory': prodCategory,
      'productId': productId,
      'prodName': prodName,
      'prodDetails': prodDetails,
      'prodPrice': prodPrice,
      'itemImgUrl': itemImgUrl,
      'prodIsAvailable': prodIsAvailable,
      'totalPrice': totalPrice,
      'itemPriceWithDiscount': itemPriceWithDiscount,
      'userId': userId,
      "selectedColorIndex": selectedColorIndex,
      "smellName": smellName,
    };
  }
}
