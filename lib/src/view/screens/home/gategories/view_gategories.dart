import 'package:ladytabtab/src/view/screens/home/export.dart';

import '../../../../models/collection/app_collections.dart';
import 'get_gategories.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _categoryStream;

  @override
  void initState() {
    super.initState();

    _categoryStream =
        AppCollections.categories.orderBy("categoryName").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _categoryStream,
        // stream: null,
        builder: (context, snapshot) {
          debugPrint("## Streams - Categories Card ##");
          if (snapshot.hasData && snapshot.data != null) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                snapshot.data!.docs;
            return Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: ScreenSize.screenWidth! * 0.90,
                  child: Text(
                    getTranslatedData(context, "explore_categories"),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const SizedBox(height: 7),
                Expanded(
                  child: AllCategoriesProducts(docs: docs),
                ),
              ],
            );
          }
          return const CustomProgressIndicator();
        },
      ),
    );
  }
}
