import '../../repositories/user_api.dart';

class UserData {
  // Get user data
  getDd(String id) {
    UserApi().getUserDataByUid(id);
  }
}
