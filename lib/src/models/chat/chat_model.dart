import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? userId;
  String? messageId;
  String? content;
  int? contentType;
  bool? sentByUser;
  bool? isRead;
  Timestamp? time;

  ChatModel({
    required this.userId,
    required this.messageId,
    required this.content,
    required this.contentType,
    required this.sentByUser,
    required this.isRead,
    required this.time,
  });

  ChatModel.fromJson(Map<String, dynamic> data) {
    userId = data['userId'];
    messageId = data['messageId'];
    content = data['content'];
    contentType = data['contentType'];
    sentByUser = data['sentByUser'];
    isRead = data['isRead'];
    time = data['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'messageId': messageId,
      'content': content,
      'contentType': contentType,
      'sentByUser': sentByUser,
      'isRead': isRead,
      'time': time,
    };
  }
}
