import 'package:firebase_auth/firebase_auth.dart';

import '../../models/collection/app_collections.dart';
import '../../models/user/user_model.dart';

class UserServices {
  final currentUser = FirebaseAuth.instance.currentUser;
  get getUserFullNameAndEmail => userFullNameAndEmail();
  Future<UserModel> userFullNameAndEmail() async {
    String? currentUserUid = currentUser!.uid;
    late UserModel userModel;

    await AppCollections.users.doc(currentUserUid).get().then(
      (value) {
        userModel = UserModel.fromJson(value.data()!);
      },
    );
    return userModel;
  }
}
