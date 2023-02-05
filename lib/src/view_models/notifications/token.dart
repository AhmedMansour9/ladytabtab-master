import 'dart:io';

import '../../../exports_main.dart';
import '../../models/collection/app_collections.dart';

class TokenApi {
  final currentUser = FirebaseAuth.instance.currentUser;
  late SharedPreferences prefs;

  Future<void> saveToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final String? tokenId = await messaging.getToken();
    if (Platform.isIOS) {
      // messaging.getToken().then((value) {
      //
      // });

    }
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (currentUser == null) {
    } else {
      await AppCollections.users.get().then((value) {
        for (var doc in value.docs) {
          if (doc['uid'] == currentUser!.uid) {
            AppCollections.users
                .doc(currentUser!.uid)
                .update({'tokenId': tokenId});
          }
        }
      });
    }
  }

  void fcmConfig() async {
    final firebaseMessage = FirebaseMessaging.instance;

    firebaseMessage.getInitialMessage();

    await firebaseMessage.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {}

      LocalNotificationService.display(message);
    });
  }

  Future<void> logouts(BuildContext ctx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance.signOut().then(
            (value) => Navigator.pushNamedAndRemoveUntil(
              ctx,
              LoginScreen.route,
              (route) => false,
            ),
          );
      prefs.clear();
    }
  }
}
