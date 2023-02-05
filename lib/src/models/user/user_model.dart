import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.uid,
    this.tokenId,
    this.fullName,
    this.email,
    this.password,
    this.mobileNo,
    this.userType,
    this.userImgUrl,
    // this.userAddress,
    this.registrationDate,
  });
  String? uid;
  String? tokenId;
  String? fullName;
  String? email;
  String? password;
  String? mobileNo;
  String? userType;
  String? userImgUrl;
  // List<dynamic>? userAddress;
  Timestamp? registrationDate;

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    mobileNo = json['mobileNo'];
    userType = json['userType'];
    userImgUrl = json['userImgUrl'];
    registrationDate = json['registrationDate'];
  }

  UserModel.fromRecipt(Map<String, dynamic> json) {
    uid = json['uid'];
    fullName = json['fullName'];
    email = json['email'];
    tokenId = json['tokenId'];
    registrationDate = json['registrationDate'];
  }

  Map<String, dynamic> toRecipt() {
    return {
      'uid': uid,
      'tokenId': tokenId,
      'fullName': fullName,
      'email': email,
      'registrationDate': registrationDate,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tokenId': tokenId,
      'fullName': fullName,
      'email': email,
      'password': password,
      'mobileNo': mobileNo,
      'userType': userType,
      'userImgUrl': userImgUrl,
      // 'userAddress': userAddress,
      'registrationDate': registrationDate,
    };
  }

  Map<String, dynamic> toLimitedMap() {
    return {
      'uid': uid,
      'tokenId': tokenId,
      'fullName': fullName,
      'email': email,
      'password': password,
      'mobileNo': mobileNo,
      'userType': userType,
      'userImgUrl': userImgUrl,
      'registrationDate': registrationDate,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'mobileNo': mobileNo,
    };
  }
}
