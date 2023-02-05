import 'package:ladytabtab/src/models/collection/app_collections.dart';

import '../models/user/user_model.dart';
import 'user_repo.dart';

class UserApi extends UserRepository {
  @override
  Future<UserModel> getUserDataByUid(String uid) async {
    late UserModel userData;
    try {
      await AppCollections.users.doc(uid).get().then((value) {
        userData = UserModel.fromJson(value.data()!);
      });
    } catch (error) {}
    return userData;
  }
}
