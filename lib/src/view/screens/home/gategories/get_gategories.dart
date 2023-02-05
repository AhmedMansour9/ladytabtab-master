import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoryPalette {
  static List<Color> colors = [
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.cyan,
    Colors.indigo,
    Colors.purple,
    Colors.redAccent,
    Colors.amber,
    Colors.blueAccent,
    Colors.deepOrangeAccent,
  ];
}

class AllCategoriesProducts extends StatelessWidget {
  const AllCategoriesProducts({
    Key? key,
    required this.docs,
  }) : super(key: key);
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return CategoryCard(
          categoryName: docs[index].data()['categoryName'],
          categoryImageUrl: docs[index].data()['categoryImageUrl'],
          color: CategoryPalette.colors[index],
        );
      },
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 14,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: 250,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: docs.length,
    );
  }
}
