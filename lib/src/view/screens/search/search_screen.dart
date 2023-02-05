import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ladytabtab/src/models/collection/app_collections.dart';

import '../../../constants/routes/routes.dart';
import '../../../models/product/product_model.dart';
import '../../../view_models/services/search_services.dart';
import '../../components/custom_progress_indicator.dart';
import '../../theme/palette.dart';
import '../../components/product_card.dart';
import '../../components/radiuz.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const route = '/searchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSelected = false;
  TextEditingController searchController = TextEditingController();

  String searchValue = '';
  var focusNode = FocusNode();
  late SearchServices searchServices;
  bool isLimitExceeded = false;
  // final SearchServices _searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();

    //TODO: check if will search using the Algolia or Firebase
    searchServices = SearchServices();
    searchServices.algoliaSearch("مخمرية");
    if (mounted) {
      setState(() {
        isLimitExceeded = isLimitExceeded;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: RawMaterialButton(
                shape: const CircleBorder(),
                onPressed: () {
                  Navigator.pop(context);
                  focusNode.canRequestFocus;
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Palette.greyColor,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 5,
              child: SizedBox(
                // width: MediaQuery.of(context).size.width * 0.90,
                height: 40,

                child: TextFormField(
                  controller: searchController,
                  focusNode: focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.words,
                  onTap: () {},
                  onChanged: (val) {
                    setState(() {
                      searchValue = val;
                    });
                    if (val.isNotEmpty) {
                      searchServices.algoliaSearch(val);
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: searchController.text.isEmpty
                        ? null
                        : SizedBox(
                            width: 22,
                            height: 22,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: RawMaterialButton(
                                constraints: const BoxConstraints(
                                  maxHeight: 20,
                                  maxWidth: 20,
                                ),
                                shape: const CircleBorder(),
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                    hintText: getTranslatedData(context, "productSearch"),
                    prefixIcon: SvgPicture.asset(
                      kSearchIcon,
                      fit: BoxFit.scaleDown,
                      color: Palette.greyColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            isLimitExceeded == false
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, FilterScreen.route);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 45,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: Radiuz.smallRadius,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/svg/Filter.svg',
                        width: 22,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        // leading: null,
        // actions: null,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              isLimitExceeded == true
                  ? _FirebaseSearchWidget(
                      searchValue: searchValue,
                      searchController: searchController,
                      searchResult: searchServices,
                    )
                  : _AlogilaSearchWidget(
                      searchResult: searchServices,
                      searchController: searchController,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FirebaseSearchWidget extends StatefulWidget {
  const _FirebaseSearchWidget({
    Key? key,
    required this.searchValue,
    required this.searchController,
    required this.searchResult,
  }) : super(key: key);

  final String searchValue;
  final TextEditingController searchController;
  final SearchServices searchResult;

  @override
  State<_FirebaseSearchWidget> createState() => _FirebaseSearchWidgetState();
}

class _FirebaseSearchWidgetState extends State<_FirebaseSearchWidget> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _searchStream;

  @override
  void initState() {
    super.initState();
    _searchStream = AppCollections.products
        .where("prodName", isGreaterThanOrEqualTo: widget.searchValue)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _searchStream,
        builder: (context, snapshot) {
          debugPrint("## Streams - Search Screen ##");
          if (snapshot.hasData &&
              snapshot.data != null &&
              widget.searchController.text.isNotEmpty &&
              widget.searchResult.isLimitExceeded == true) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                ProductModel productModel =
                    ProductModel.fromJson(snapshot.data!.docs[index].data());
                return ExploreProductCard(
                  productModel: productModel,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutesPaths.productDetails,
                      arguments: productModel,
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              widget.searchController.text.isEmpty &&
              widget.searchResult.isLimitExceeded == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    kSearchIcon,
                    width: 50,
                    // height: 300,
                    color: Palette.greyColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    getTranslatedData(context, "emptySearch"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: Palette.greyColor),
                  ),
                ],
              ),
            );
          }
          return const CustomProgressIndicator();
        },
      ),
    );
  }
}

class _AlogilaSearchWidget extends StatelessWidget {
  const _AlogilaSearchWidget({
    Key? key,
    required this.searchResult,
    required this.searchController,
  }) : super(key: key);

  final SearchServices searchResult;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<AlgoliaObjectSnapshot>>(
        future: searchResult.algoliaSearch(searchController.text),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty &&
              searchController.text.isNotEmpty) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                ProductModel productModel =
                    ProductModel.fromJson(snapshot.data![index].data);
                return ExploreProductCard(
                  productModel: productModel,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutesPaths.productDetails,
                      arguments: productModel,
                    );
                  },
                );
              },
            );
          } else if (snapshot.data == null || searchController.text.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    kSearchIcon,
                    width: 50,
                    // height: 300,
                    color: Palette.greyColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    getTranslatedData(context, "emptySearch"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: Palette.greyColor),
                  ),
                ],
              ),
            );
          } else if (snapshot.data == null &&
              searchController.text.isNotEmpty) {
            return Center(
              child: Text(
                "لا يوجد نتائج",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.grey,
                    ),
              ),
            );
          } else if (snapshot.data!.isEmpty &&
              searchController.text.isNotEmpty) {
            return Center(
              child: Text(
                "لا يوجد نتائج",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.grey,
                    ),
              ),
            );
          }
          return const CustomProgressIndicator();
        },
      ),
    );
  }
}

class CompanyWidget {
  const CompanyWidget(this.name);
  final String name;
}
