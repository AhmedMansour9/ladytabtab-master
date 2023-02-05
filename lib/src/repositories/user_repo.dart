import '../models/user/user_model.dart';

abstract class UserRepository {
  // GET USER DATA
  Future<UserModel> getUserDataByUid(String uid);
}
