import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionModel {
  CollectionModel(this.collection, this.category);
  final CollectionReference<Map<String, dynamic>> collection;
  final String category;
}
