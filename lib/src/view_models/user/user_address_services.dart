import 'package:ladytabtab/src/models/collection/app_collections.dart';

class UserAddressServices {
  Future<List<Map<String, dynamic>>> getUserAddressById(String uid) async {
    List<Map<String, dynamic>> userAddress = [];

    await AppCollections.users.doc(uid).get().then((value) {
      if (value.get("userAddress") != null || value.get("userAddress") != '') {
        userAddress = value.get("userAddress");
      }
    });
    return userAddress;
  }

  Future<void> deleteUserAddressById(String currentUserId, String uid) async {
    await AppCollections.users
        .doc(currentUserId)
        .collection("Addresses")
        .doc(uid)
        .delete();
  }
}
