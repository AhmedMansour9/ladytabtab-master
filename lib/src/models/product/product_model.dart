// class ProductModel {
//   ProductModel({
//     this.prodName,
//     this.prodDetails,
//     this.prodAvailableQty,
//     this.prodPrice,
//     this.prodCategory,
//     this.prodImgUrl,
//     this.prodImgName,
//     this.prodIsAvailable,
//     this.productId,
//     this.prodPriceWithDiscount,
//     this.prodHasOffer,
//     this.prodImgsUrls,
//     this.prodDiscountPercentage,
//   });
//   String? prodName;
//   String? prodDetails;
//   int? prodAvailableQty;
//   double? prodPrice;
//   String? prodCategory;
//   String? prodImgUrl;
//   String? prodImgName;
//   bool? prodIsAvailable;
//   String? productId;
//   double? prodPriceWithDiscount;
//   bool? prodHasOffer;
//   List? prodImgsUrls;
//   double? prodDiscountPercentage;

//   // Named Constractor
//   ProductModel.fromJson(Map<String, dynamic> data) {
//     prodName = data['prodName'];
//     prodDetails = data['prodDetails'];
//     prodAvailableQty = data['prodAvailableQty'];
//     prodPrice = double.parse(data['prodPrice'].toString());
//     prodCategory = data['prodCategory'];
//     prodImgUrl = data['prodImgUrl'];
//     prodImgName = data['prodImgName'];
//     prodIsAvailable = data['prodIsAvailable'];
//     productId = data['productId'];
//     prodPriceWithDiscount = (data['prodPriceWithDiscount'] == '' ||
//             data['prodPriceWithDiscount'] == null)
//         ? 0.0
//         : data['prodPriceWithDiscount'].toDouble();
//     prodHasOffer = data['prodHasOffer'];
//     prodImgsUrls = data['prodImgsUrls'];
//     prodDiscountPercentage =
//         double.parse(data['prodprodDiscountPercentage'].toString());
//   }

//   // Method returns map
//   Map<String, dynamic> toMap() {
//     return {
//       "prodName": prodName,
//       "prodDetails": prodDetails,
//       "prodAvailableQty": prodAvailableQty,
//       "prodPrice": prodPrice,
//       "prodCategory": prodCategory,
//       "prodImgUrl": prodImgUrl,
//       "prodImgName": prodImgName,
//       "prodIsAvailable": prodIsAvailable,
//       "productId": productId,
//       "prodPriceWithDiscount": prodPriceWithDiscount,
//       "prodHasOffer": prodHasOffer,
//       "prodImgsUrls": prodImgsUrls,
//       "prodprodDiscountPercentage": prodDiscountPercentage,
//     };
//   }
// }

class ProductModel {
  ProductModel({
    this.prodUid,
    this.prodName,
    this.prodDetails,
    this.prodCategory,
    this.prodImgName,
    this.prodImgUrl,
    this.prodComponents,
    this.prodHowUse,
    this.prodNotes,
    this.prodImgsListNames,
    this.prodImgsUrls,
    this.prodSmells,
    this.prodColors,
    this.prodPrice,
    this.prodPriceWithDiscount,
    this.prodDiscountPercentage,
    this.prodSize,
    this.prodIsAvailable,
    this.prodHasOffer,
    this.prodIsOnSlider,
    this.prodAvailableQty,
  });

  final String? prodUid;
  final String? prodName;
  final String? prodDetails;
  final String? prodCategory;
  final String? prodImgName;
  final String? prodImgUrl;
  final String? prodComponents;
  final String? prodHowUse;
  final String? prodNotes;
  final String? prodSize;

  final List<dynamic>? prodImgsListNames;
  final List<dynamic>? prodImgsUrls;
  final List<dynamic>? prodSmells;
  final List<dynamic>? prodColors;

  final double? prodPrice;
  final double? prodPriceWithDiscount;
  final int? prodDiscountPercentage;

  final bool? prodIsAvailable;
  final bool? prodHasOffer;
  final bool? prodIsOnSlider;

  final int? prodAvailableQty;

  // Name constractor
  factory ProductModel.fromJson(Map<String, dynamic> data) {
    return ProductModel(
      prodUid: data['prodUid'],
      prodName: data['prodName'],
      prodDetails: data['prodDetails'],
      prodCategory: data['prodCategory'],
      prodImgName: data['prodImgName'],
      prodImgUrl: data['prodImgUrl'],
      prodComponents: data['prodComponents'],
      prodHowUse: data['prodHowUse'],
      prodNotes: data['prodNotes'],
      prodImgsListNames: data['prodImgsListNames'],
      prodImgsUrls: data['prodImgsUrls'],
      prodSmells: data['prodSmells'],
      prodColors: data['prodColors'],
      prodPrice: double.parse(data['prodPrice'].toString()),
      prodPriceWithDiscount:
          double.parse(data['prodPriceWithDiscount'].toString()),
      // prodDiscountPercentage:
      //     double.parse(data['prodDiscountPercentage'].toString()),
      prodDiscountPercentage: data['prodDiscountPercentage'],
      prodSize: data['prodSize'],
      prodIsAvailable: data['prodIsAvailable'],
      prodHasOffer: data['prodHasOffer'],
      prodIsOnSlider: data['prodIsOnSlider'],
      prodAvailableQty: data['prodAvailableQty'],
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      "prodUid": prodUid,
      "prodName": prodName,
      "prodDetails": prodDetails,
      "prodCategory": prodCategory,
      "prodImgName": prodImgName,
      "prodImgUrl": prodImgUrl,
      "prodComponents": prodComponents,
      "prodHowUse": prodHowUse,
      "prodNotes": prodNotes,
      "prodImgsListNames": prodImgsListNames,
      "prodImgsUrls": prodImgsUrls,
      "prodSmells": prodSmells,
      "prodColors": prodColors,
      "prodPrice": prodPrice,
      "prodPriceWithDiscount": prodPriceWithDiscount,
      "prodDiscountPercentage": prodDiscountPercentage,
      "prodSize": prodSize,
      "prodIsAvailable": prodIsAvailable,
      "prodHasOffer": prodHasOffer,
      "prodIsOnSlider": prodIsOnSlider,
      "prodAvailableQty": prodAvailableQty,
    };
  }

  Map<String, dynamic> toUpdates() {
    return {
      "prodName": prodName,
      "prodDetails": prodDetails,
      "prodCategory": prodCategory,
      "prodComponents": prodComponents,
      "prodHowUse": prodHowUse,
      "prodNotes": prodNotes,
      "prodSmells": prodSmells,
      "prodColors": prodColors,
      "prodPrice": prodPrice,
      "prodPriceWithDiscount": prodPriceWithDiscount,
      "prodDiscountPercentage": prodDiscountPercentage,
      "prodSize": prodSize,
      "prodHasOffer": prodHasOffer,
      "prodIsOnSlider": prodIsOnSlider,
      "prodAvailableQty": prodAvailableQty,
    };
  }
}
