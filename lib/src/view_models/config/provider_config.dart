// import 'package:provider/single_child_widget.dart';

// import '../../../exports_main.dart';
// import '../../models/category/category_model.dart';
// import '../../models/collection/app_collections.dart';

// class ProviderConfig {
//   static List<SingleChildWidget> providers = [
//     ChangeNotifierProvider(create: (context) => TokenApi()),
//     StreamProvider<CartDocument>(
//       create: (context) => CartServices().cartQuantity(),
//       initialData: CartDocument(0),
//     ),
//     StreamProvider<List<Categoryi>>(
//       create: (context) {
//         return AppCollections.categories
//             .orderBy("categoryName")
//             .snapshots()
//             .map((event) {
//           return event.docs.map(
//             (doc) {
//               return Categoryi.fromJson(doc.data()['categoryName']);
//             },
//           ).toList();
//         });
//       },
//       initialData: const [],
//     ),
//     ChangeNotifierProvider(create: (context) => AppLanguage()),
//     ChangeNotifierProvider(create: (context) => ProductServices()),
//     ChangeNotifierProvider(create: (context) => AuthServices()),
//     ChangeNotifierProvider(create: (context) => UserServices()),
//     ChangeNotifierProvider(create: (context) => UserOrdersServices()),
//     ChangeNotifierProvider(create: (context) => UserAddressServices()),

//     // Algolia Search
//     ChangeNotifierProvider(create: (context) => SearchServices()),
//   ];
// }
