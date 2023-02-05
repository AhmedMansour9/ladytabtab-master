class WishlistModel {
  WishlistModel({
    this.prodUid,
    this.userUid,
  });
  String? prodUid;
  String? userUid;

  // Named Constractor
  WishlistModel.fromJson(Map<String, dynamic> data) {
    prodUid = data['prodUid'];
    userUid = data['userUid'];
  }

  // Method returns map
  Map<String, dynamic> toMap() {
    return {
      "prodUid": prodUid,
      "userUid": userUid,
    };
  }
}
