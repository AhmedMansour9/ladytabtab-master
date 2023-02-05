import 'package:google_sign_in/google_sign_in.dart';
import 'package:ladytabtab/exports_main.dart';
import 'package:ladytabtab/src/models/user/user_model.dart';

abstract class FirebaseAuthServices {
  final auth = FirebaseAuth.instance;
  loginWithEmail(String email, String password);

  loginWithGoogle();

  loginWithFacebook();

  loginWithApple();
}

class UserAuth implements FirebaseAuthServices {
  @override
  loginWithApple() {}

  @override
  Future<UserModel?> loginWithEmail(String email, String password) async {
    return await auth
        .signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        )
        .then(
          (value) => UserModel(
            uid: value.user!.uid,
            fullName: value.user!.displayName,
            email: value.user!.email ?? value.user!.phoneNumber,
            password: null,
            mobileNo: value.user!.phoneNumber,
          ),
        );
  }

  @override
  loginWithFacebook() {}

  @override
  Future<UserModel> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential).then(
          (value) => UserModel(
            uid: value.user!.uid,
            fullName: value.user!.displayName,
            email: value.user!.email ?? value.user!.phoneNumber,
            password: null,
            mobileNo: value.user!.phoneNumber,
          ),
        );
  }

  @override
  FirebaseAuth get auth {
    throw UnimplementedError();
  }
}
