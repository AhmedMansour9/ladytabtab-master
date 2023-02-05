import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ladytabtab/exports_main.dart';
import 'package:ladytabtab/src/view/components/shared/custom_app_bar.dart';
import 'package:ladytabtab/src/view/screens/main/no_internet_connection.dart';

import '../../constants/routes/routes.dart';
import '../../models/collection/app_collections.dart';
import '../../models/collection/collection_model.dart';
import '../../view_models/products/products_view_model.dart';
import 'custom_progress_indicator.dart';
import 'offers_card.dart';
import 'product_card.dart';
import 'shared/get_translated_data.dart';

class OffersTabBarView extends StatefulWidget {
  const OffersTabBarView({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<OffersTabBarView> createState() => _OffersTabBarViewState();
}

class _OffersTabBarViewState extends State<OffersTabBarView> {
  List allData = [];

  bool noData = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: (widget.category == "All" ||
              widget.category == "ALL" ||
              widget.category == "الكل" ||
              widget.category == "all")
          ? AppCollections.products.where("prodHasOffer", isEqualTo: true).get()
          : AppCollections.products
              .where("prodCategory", isEqualTo: widget.category)
              .where("prodHasOffer", isEqualTo: true)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.docs.isNotEmpty) {
          var docs = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            // scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              ProductModel productModel =
                  ProductModel.fromJson(docs[index].data());
              return OffersCard(
                title: productModel.prodName.toString(),
                subtitle: productModel.prodDetails.toString(),
                price: productModel.prodPrice!.toDouble(),
                prodDiscountPercentage: productModel.prodDiscountPercentage!,
                prodPriceWithDiscount:
                    productModel.prodPriceWithDiscount!.toDouble(),
                imageUrl: productModel.prodImgUrl.toString(),
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
            snapshot.data!.docs.isEmpty) {
          return SizedBox.expand(
            child: Center(
              child: Text(
                getTranslatedData(context, "noProductsWithOffer"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Palette.greyColor,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
              ),
            ),
          );
        }
        return const CustomProgressIndicator();
      },
    );
  }
}

class ViewProductsByCategoryScreen extends StatefulWidget {
  const ViewProductsByCategoryScreen({Key? key, required this.categoryName})
      : super(key: key);

  final String categoryName;

  @override
  State<ViewProductsByCategoryScreen> createState() =>
      _ViewProductsByCategoryScreenState();
}

class _ViewProductsByCategoryScreenState
    extends State<ViewProductsByCategoryScreen> {
  List allData = [];
  List pageData = [];

  bool noData = false;
  bool hasConne = true;

  Future<bool> checkInternetConnctio() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Widget Category by pro");
    checkInternetConnctio().then((connection) {
      if (!connection) {
        if (mounted) {
          setState(() {
            hasConne = false;
          });
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const NoInternetConnection()),
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("### LIST OF PRODUCTS BY CATEGORY ###");
    return !hasConne
        ? const NoInternetConnection()
        : Scaffold(
            appBar: CustomAppBar(
              title: widget.categoryName.toUpperCase(),
              // title: "Test AppBar",
            ),
            body: FutureBuilder<List<ProductModel>>(
              future: ProductsServices().getProductsByCategory(
                CollectionModel(AppCollections.products, widget.categoryName),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return _ViewListProducts(products: snapshot.data!);
                } else if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      getTranslatedData(context, "noProducts"),
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const CustomProgressIndicator();
              },
            ),
          );
  }
}

class _ViewListProducts extends StatelessWidget {
  const _ViewListProducts({Key? key, required this.products}) : super(key: key);

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: products.length,
      itemBuilder: (context, index) {
        ProductModel productModel = products[index];
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
  }
}
