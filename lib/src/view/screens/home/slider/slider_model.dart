class SliderModel {
  String? prodName;
  String? itemDescription;
  double? prodPrice;
  double? itemPriceWithDiscount;
  String? itemImageUrl;
  bool? prodHasOffer;

  SliderModel({
    required this.prodName,
    required this.itemDescription,
    required this.prodPrice,
    required this.itemPriceWithDiscount,
    required this.itemImageUrl,
    required this.prodHasOffer,
  });

  factory SliderModel.fromMap(Map<String, dynamic> data) {
    return SliderModel(
      prodName: data["prodName"],
      itemDescription: data["prodDetails"],
      prodPrice: data["prodPrice"] + 0.0,
      itemPriceWithDiscount: data["prodPriceWithDiscount"] == null
          ? 0.0
          : data["prodPriceWithDiscount"] + 0.0,
      itemImageUrl: data["prodImgUrl"],
      prodHasOffer: data["prodHasOffer"],
    );
  }
}
