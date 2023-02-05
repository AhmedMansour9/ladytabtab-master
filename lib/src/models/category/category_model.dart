class CartDocument {
  CartDocument(this.cartCounter);

  final int? cartCounter;

  factory CartDocument.fromJson(int data) {
    return CartDocument(data);
  }
}

class Categoryi {
  Categoryi(this.categoryTitle);
  final String categoryTitle;
  static const String g = "";

  factory Categoryi.fromJson(String data) {
    return Categoryi(data);
  }
}
