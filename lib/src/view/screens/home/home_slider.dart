import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports_main.dart';
import '../../../blocs/slider_bloc/sliderbloc_bloc.dart';
import '../../components/custom_progress_indicator.dart';
import '../../components/shared/screens_size.dart';

class HomeSliderViewTest extends StatefulWidget {
  const HomeSliderViewTest({Key? key}) : super(key: key);

  @override
  State<HomeSliderViewTest> createState() => _HomeSliderViewTestState();
}

class _HomeSliderViewTestState extends State<HomeSliderViewTest> {
  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return BlocBuilder<SliderBloc, SliderblocState>(
      builder: (context, state) {
        if (state is SliderDataState) {
          return _SliderView(slidersItems: state.getAllSliders);
        } else {
          return const CustomProgressIndicator();
        }
      },
    );
  }
}

class BuildIndicators extends StatelessWidget {
  const BuildIndicators({
    Key? key,
    required this.itemIndex,
    required this.currentIndex,
    this.unselectedColor = Palette.unactiveIconColor,
  }) : super(key: key);

  final int itemIndex;
  final int currentIndex;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return SizedBox(
      width: ScreenSize.screenWidth,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemIndex, (index) {
          return AnimatedContainer(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 350),
            width: index == currentIndex ? 10 : 7,
            height: index == currentIndex ? 10 : 7,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex
                  ? Palette.primaryColor
                  : const Color.fromARGB(255, 87, 87, 87),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SliderView extends StatefulWidget {
  const _SliderView({
    required this.slidersItems,
    Key? key,
  }) : super(key: key);

  final Future<List<ProductModel>> slidersItems;

  @override
  State<_SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<_SliderView> {
  int currentIndex = 0;
  List<ProductModel> products = [];
  @override
  void initState() {
    super.initState();
    widget.slidersItems.then((items) {
      if (mounted) {
        setState(() {
          products = items;
        });
      }
    });
  }

//   @override
  @override
  Widget build(BuildContext context) {
    debugPrint("## Home - Slider Viewer Builder ##");

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (scroll) {
              scroll.disallowIndicator();
              return false;
            },
            child: products.isEmpty
                ? const CustomProgressIndicator()
                : CarouselSlider.builder(
                    // carouselController: _carouselController,
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      height: ScreenSize.screenHeight,
                      autoPlay: true,
                      onPageChanged: (val, reason) {
                        setState(() {
                          currentIndex = val;
                        });
                      },
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index, eall) {
                      ProductModel productModel = products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                productModel: productModel,
                              ),
                            ),
                          );

                          // );
                          // Navigator.pushNamed(
                          //   context,
                          //   RoutesPaths.productDetails,
                          //   arguments: productModel,
                          // );
                        },
                        child: SizedBox(
                          width: ScreenSize.screenWidth!,
                          child: products[index].prodImgUrl == null ||
                                  products[index].prodImgUrl!.isEmpty
                              ? const Center(
                                  child: CustomLogo(size: 133),
                                )
                              : CachedNetworkImage(
                                  width: double.maxFinite,
                                  imageUrl:
                                      products[index].prodImgUrl.toString(),
                                  fit: BoxFit.cover,
                                  // placeholder: (context, url) {
                                  //   return const CustomProgressIndicator();
                                  // },
                                  errorWidget: (context, url, error) {
                                    return const Center(
                                      child: CustomLogo(),
                                    );
                                  },
                                ),
                        ),
                      );
                    },
                  ),
          ),
          Positioned(
            bottom: 10,
            child: BuildIndicators(
              itemIndex: products.length,
              currentIndex: currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}
