import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chat/chat_model.dart';
import '../../models/collection/app_collections.dart';

class ChatServices {
  Future setNewMessage({
    required String userId,
    String? messageId,
    required String content,
    required int contentType,
    required bool sentByUser,
    required bool isRead,
    required Timestamp time,
  }) async {
    var docRef = AppCollections.chats.doc();
    var docId = docRef.id;
    ChatModel chatModel = ChatModel(
      userId: userId,
      messageId: docId,
      content: content,
      contentType: contentType,
      sentByUser: sentByUser,
      isRead: isRead,
      time: time,
    );
    Map<String, dynamic> mapData = chatModel.toMap();

    AppCollections.chats.doc(docId).set(mapData).then((value) async {});
  }
}
