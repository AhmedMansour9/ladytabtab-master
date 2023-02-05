import 'package:algolia/algolia.dart';

class SearchServices {
  // Is the limit exceeded?
  late bool _limitExceeded = false;

  bool get isLimitExceeded => _limitExceeded;
  // Get list of product depends on text
  Future<List<AlgoliaObjectSnapshot>> algoliaSearch(String searchText) async {
    try {
      Algolia algolia = const Algolia.init(
        applicationId: '8W80YE3RSM',
        apiKey: '775fc18739935d9e7b07bc3a44c5bfcd',
      );

      AlgoliaQuery query = algolia.instance.index('ladytabtab');

      if (searchText.isNotEmpty && searchText != '') {
        query = query.query(searchText);

        Future<AlgoliaQuerySnapshot> snap = query.getObjects();
        return snap.then((value) => value.hits);
      }
    } on AlgoliaError catch (algoliaError) {
      if (algoliaError.statusCode == 403 &&
          algoliaError.error.containsValue(
            "Operations quota exceeded. Change plan to get more Operations.",
          )) {
        _limitExceeded = true;
        return [];
      }
    }
    // notifyListeners();
    return [];
  }

  Future<List<AlgoliaObjectSnapshot>> filterBy(
    String priceStart,
    String priceEnd,
    String categoryName,
  ) async {
    try {
      Algolia algolia = const Algolia.init(
        applicationId: '8W80YE3RSM',
        apiKey: '775fc18739935d9e7b07bc3a44c5bfcd',
      );

      AlgoliaQuery query = algolia.instance.index('ladytabtab');

      String category = 'prodCategory:$categoryName';
      // String color = 'prodColors.colorName:Green';
      // query = query.facetFilter(color);
      query = query.facetFilter(category);
      query = query.filters('prodPrice: $priceStart TO $priceEnd');

      // if (priceStart.isNotEmpty && priceEnd.isNotEmpty) {

      return (await query.getObjects()).hits;
      // }
      // return [];
    } on AlgoliaError catch (errorCatched) {
      if (errorCatched.statusCode == 403 &&
          errorCatched.error.containsValue(
            "Operations quota exceeded. Change plan to get more Operations.",
          )) {
        return [];
      }
    }
    return [];
  }

  // Get list of product depends on text
  Future<AlgoliaQuerySnapshot> getAlgoliaObjs() async {
    Algolia algolia = const Algolia.init(
      applicationId: '8W80YE3RSM',
      apiKey: '775fc18739935d9e7b07bc3a44c5bfcd',
    );

    AlgoliaQuery query = algolia.instance.index('ladytabtab');
    return query.getObjects();
  }
}
