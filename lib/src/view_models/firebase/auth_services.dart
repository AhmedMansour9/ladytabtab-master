import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/collection/app_collections.dart';
import '../../models/user/user_model.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Register - Sign up
  Future signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login using email & password
  Future logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future logOut() async {
    await auth.signOut();
  }

  Future logOutGoogle() async {
    await auth.signOut();
  }

  Future logOutFacebook() async {
    await auth.signOut();
  }

  Future deleteUser() async {
    if (auth.currentUser != null) {
      await auth.currentUser!
          .delete()
          .then((value) => debugPrint("User deleted"));
    }
  }

  // Login using Google account
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithFacebook() async {
    UserCredential? userCredential;
    try {
      // Trigger the sign-in flow

      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ["public_profile", "email"],
      ).then((value) => value);

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      // switch (loginResult.status.name) {
      //   case "success":
      //     // Create a credential from the access token
      userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      // }
    } catch (error) {
      debugPrint("Error $error");
    }
    return userCredential;
  }

  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  // Add new user data to firestore
  Future addUserData({
    required String uid,
    required String? fullName,
    required String? email,
    required String? password,
    required String? mobileNo,
  }) async {
    // TODO: will merge user data if exists.
    // Check if the current user exists or not
    await AppCollections.users.doc(uid).get().then((value) async {
      if (value.exists) {
        // TODO: USER ALREADY EXISTS
        debugPrint("## USER EXISTS - USER UID: ${value.id}");
      } else {
        UserModel userModel = UserModel(
          uid: uid,
          fullName: fullName,
          email: email,
          password: password,
          mobileNo: mobileNo,
          userType: 'user',
          userImgUrl: '',
          registrationDate: Timestamp.fromDate(DateTime.now()),
        );
        return await AppCollections.users.doc(uid).set(
              userModel.toLimitedMap(),
              SetOptions(merge: true),
            );
      }
    });
  }

  // Get user data - profile
  Stream<QuerySnapshot> getUserData(String userUid) {
    return AppCollections.users.where('uid', isEqualTo: userUid).snapshots();
  }

  // Edit user data - profile
  // Future editUserData({
  //   String? newFullName,
  //   String? newLastName,
  //   String? newMobileNo,
  //   String? newEmail,
  //   String? newPassword,
  // }) async {
  //   String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  //   UserModel userModel = UserModel(
  //     fullName: newFullName,
  //     mobileNo: newMobileNo ?? UserModel().mobileNo,
  //     email: newEmail ?? UserModel().email,
  //     password: newPassword ?? UserModel().password,
  //   );
  //   AppCollections.users.doc(currentUserUid).update(userModel.toUpdateMap());
  // }

  // End the class
}
