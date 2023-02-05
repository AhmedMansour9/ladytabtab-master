import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import '../../../constants/routes/routes.dart';
import '../../../models/product/product_model.dart';
import '../../components/custom_progress_indicator.dart';
import '../../components/product_card.dart';
import '../../../view_models/services/search_services.dart';

class FilterResultScreen extends StatefulWidget {
  const FilterResultScreen({
    Key? key,
    this.priceFrom,
    this.priceTo,
    this.category,
  }) : super(key: key);

  final String? priceFrom;
  final String? priceTo;
  final String? category;

  @override
  State<FilterResultScreen> createState() => _FilterResultScreenState();
}

class _FilterResultScreenState extends State<FilterResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  final SearchServices _searchServices = SearchServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<AlgoliaObjectSnapshot>>(
                  future: _searchServices.filterBy(
                    widget.priceFrom!,
                    widget.priceTo!,
                    widget.category!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
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
                    } else if (snapshot.data == null) {
                      return const CustomProgressIndicator();
                    }
                    return Center(
                      child: Text(
                        "لا يوجد نتائج",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
