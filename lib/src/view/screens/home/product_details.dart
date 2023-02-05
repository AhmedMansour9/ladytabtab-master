import 'package:fluttertoast/fluttertoast.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';

import '../../../constants/routes/routes.dart';
import '../../../models/collection/app_collections.dart';
import '../../components/custom_arrow_back.dart';
import '../../components/product_card.dart';
import '../../widgets/buy_and_favorite.dart';
import '../../widgets/cart_button_counter.dart';
import 'home_slider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    Key? key,
    required this.productModel,
    this.isWishListItem,
    this.productId,
  }) : super(key: key);

  final ProductModel productModel;
  final bool? isWishListItem;
  final String? productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  late PageController pageController;
  int itemIndex = 4;
  int currentIndex = 0;

  late String productLogo;
  List? productImages = [];
  int? selectedIndex;
  String? _selectedSmell;

  final List<bool> _isExpandedList = [true, true, true];

  late Stream<QuerySnapshot<Map<String, dynamic>>> _cartStream;

  // TODO: COMPARE THE PRODUCT IS IN CART OR NOT

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    _cartStream = AppCollections.cart
        .where(
          "productId",
          isEqualTo: widget.productModel.prodUid,
        )
        .snapshots();

    productImages = widget.productModel.prodImgsUrls;
    //
    productLogo = widget.productModel.prodImgUrl ?? '';

    if ((productImages == null || productImages!.isEmpty) &&
        productLogo.isNotEmpty) {
      productImages = [];
      productImages!.add(productLogo);
    } else if (productImages != null && productLogo.isNotEmpty) {
      if (!productImages!.contains(productLogo)) {
        productImages!.insert(0, productLogo);
      }
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    //
    final data = widget.productModel;
    ScreenSize().init(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: ScreenSize.screenHeight! * 0.40,
            collapsedHeight: ScreenSize.screenHeight! * 0.15,
            // toolbarHeight: ScreenSize.screenHeight! * 0.10,
            leading: CustomArrowBack(ctx: context),
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                width: ScreenSize.screenWidth,
                // height: 70,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                decoration: const BoxDecoration(
                  color: Palette.mainBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        data.prodName!.toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text(
                      "${data.prodPrice.toString()} ${getTranslatedData(context, "egyPrice")}",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Palette.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    FavoriteButton(
                      prodUid: data.prodUid!,
                    ),
                  ],
                ),
              ),
            ),
            centerTitle: false,
            excludeHeaderSemantics: true,
            floating: true,
            actions: const [
              TopCartCounter(),
            ],
            flexibleSpace: FlexibleSpaceBar(
              // background: Image.asset(facebookIcon),

              background: productImages == null ||
                      productImages == [] ||
                      productImages!.isEmpty
                  ? const SizedBox(height: 10)
                  : SizedBox(
                      height: 220,
                      // width: double.infinity,
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (scroll) {
                          scroll.disallowIndicator();
                          return false;
                        },
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                              // controller: pageController,
                              itemCount: productImages!.length,

                              options: CarouselOptions(
                                viewportFraction: 1.0,
                                height: ScreenSize.screenHeight,
                                autoPlay: false,
                                onPageChanged: (val, reason) {
                                  setState(() {
                                    currentIndex = val;
                                  });
                                },
                              ),
                              itemBuilder: (context, index, index2) {
                                return productImages![index] == null ||
                                        productImages![index]!.isEmpty
                                    ? const SizedBox()
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            RoutesPaths.viewImage,
                                            arguments: productImages![index],
                                          );
                                        },
                                        child: SizedBox(
                                          width: ScreenSize.screenWidth,
                                          child: CachedNetworkImage(
                                            imageUrl: productImages![index],
                                            fit: BoxFit.cover,
                                            // placeholder: (context, url) {
                                            //   return const CustomProgressIndicator();
                                            // },
                                            errorWidget: (
                                              context,
                                              url,
                                              error,
                                            ) {
                                              return const Center(
                                                child: CustomLogo(),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                              },
                            ),

                            // Build indicators
                            Positioned(
                              bottom: 75,
                              child: BuildIndicators(
                                itemIndex: productImages == null
                                    ? 0
                                    : productImages!.length,
                                currentIndex: currentIndex,
                                unselectedColor: Palette.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Sizes
                if (data.prodSize != null && data.prodSize!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 7,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          getTranslatedData(context, "prodSize"),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Container(
                          alignment: Alignment.center,
                          // color: Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 7,
                          ),
                          child: Text(data.prodSize.toString()),
                        ),
                      ],
                    ),
                  ),

                // const Divider(),
                if (data.prodColors != null && data.prodColors!.isNotEmpty)
                  const SizedBox(height: 20),
                // Colors

                if (data.prodColors != null && data.prodColors!.isNotEmpty)
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _cartStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.docs.isNotEmpty) {
                        int isSelectedIndex = snapshot.data!.docs.single
                            .get("selectedColorIndex");
                        selectedIndex = isSelectedIndex;
                        return Row(
                          children: [
                            Text(
                              "${getTranslatedData(context, "availableColors")} ",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            const SizedBox(width: 12),
                            ...List.generate(
                              data.prodColors!.length,
                              (index) => GestureDetector(
                                onTap: () {},
                                child: AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 100,
                                  ),
                                  alignment: Alignment.center,
                                  width: 25,
                                  height: 25,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: selectedIndex == index
                                        ? Border.all(
                                            width: 3,
                                            color: Colors.white,
                                          )
                                        : Border.all(
                                            width: 0,
                                            color: Colors.transparent,
                                          ),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius:
                                            selectedIndex == index ? 20 : 0,
                                        color: selectedIndex == index
                                            ? const Color(
                                                0xFFBDBDBD,
                                              )
                                            : Colors.transparent,
                                      )
                                    ],
                                    color: Color(
                                      int.parse(
                                        data.prodColors![index]['colorCode'],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Text(
                            "${getTranslatedData(context, "availableColors")} ",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          const SizedBox(width: 12),
                          ...List.generate(
                            data.prodColors!.length,
                            (index) => Container(
                              width: 45,
                              height: 45,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: Material(
                                // shadowColor: ,
                                // color: Colors.red,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                animationDuration: const Duration(
                                  milliseconds: 100,
                                ),
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  radius: 20,
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      final String colorName =
                                          data.prodColors![index]['colorName'];
                                      Fluttertoast.cancel();
                                      Fluttertoast.showToast(
                                        msg: "$colorName color selected",
                                      );
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 100,
                                    ),
                                    alignment: Alignment.center,
                                    width: 25,
                                    height: 25,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: selectedIndex == index
                                          ? Border.all(
                                              width: 3,
                                              color: Colors.white,
                                            )
                                          : Border.all(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius:
                                              selectedIndex == index ? 20 : 0,
                                          color: selectedIndex == index
                                              ? const Color(
                                                  0xFFBDBDBD,
                                                )
                                              : Colors.transparent,
                                        )
                                      ],
                                      color: Color(
                                        int.parse(
                                          data.prodColors![index]['colorCode'],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                // const Divider(),
                if (data.prodSmells != null && data.prodSmells!.isNotEmpty)
                  const SizedBox(height: 20),

                // Smells
                if (data.prodSmells != null && data.prodSmells!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslatedData(context, "prodSmells")} ",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Color(0x30A6D2C3),
                          ),
                          child: StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
                            stream: _cartStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.docs.isNotEmpty) {
                                String currentSelectedSmell = snapshot
                                    .data!.docs.single
                                    .get("smellName")
                                    .toString();
                                return Center(
                                  child: Text(currentSelectedSmell),
                                );
                              } else {
                                return DropdownButton<dynamic>(
                                  underline: const SizedBox(),
                                  hint: _selectedSmell != null
                                      ? Text(
                                          _selectedSmell!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        )
                                      : Text(
                                          getTranslatedData(
                                            context,
                                            "selectUrSmell",
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                  items: data.prodSmells!.map((smell) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: smell,
                                      onTap: () {
                                        Fluttertoast.cancel();
                                        Fluttertoast.showToast(
                                          msg: "$smell smell selected",
                                        );
                                      },
                                      child: Text(
                                        smell.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedSmell = val;
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                ExpansionPanelList(
                  elevation: 0.0,
                  animationDuration: const Duration(milliseconds: 350),
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (int index, bool isExpanded) {
                    if (mounted) {
                      setState(() {
                        _isExpandedList[index] = !isExpanded;
                      });
                    }
                  },
                  children: [
                    if (data.prodDetails != null &&
                        data.prodDetails!.isNotEmpty)
                      buildExpansionTile(
                        getTranslatedData(context, "prodDetails"),
                        data.prodDetails!,
                        _isExpandedList[0],
                      ),
                    if (data.prodComponents != null &&
                        data.prodComponents!.isNotEmpty)
                      buildExpansionTile(
                        getTranslatedData(context, "prodComponents"),
                        data.prodComponents!,
                        _isExpandedList[1],
                      ),
                    if (data.prodHowUse != null && data.prodHowUse!.isNotEmpty)
                      buildExpansionTile(
                        getTranslatedData(context, "howToUse"),
                        data.prodHowUse!,
                        _isExpandedList[2],
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // End class

                BuyFavoriteButtons(
                  productModel: data,
                  selectedIndexColor: selectedIndex,
                  selectedSmells: _selectedSmell,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ExpansionPanel buildExpansionTile(
    String titleTranslated,
    String bodyContentText,
    bool isExpanded,
  ) {
    var theme = Theme.of(context);
    return ExpansionPanel(
      isExpanded: isExpanded,
      canTapOnHeader: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text(
            titleTranslated,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            bodyContentText,
            style: theme.textTheme.subtitle2!.copyWith(
              color: const Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ),
      ),
    );
  }
}
