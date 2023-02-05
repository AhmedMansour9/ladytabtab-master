part of 'sliderbloc_bloc.dart';

@immutable
abstract class SliderblocState {}

class SliderblocInitial extends SliderblocState {}

class SliderDataState extends SliderblocState {
  SliderDataState();

  Future<List<ProductModel>> get getAllSliders => _getSliders();

  Future<List<ProductModel>> _getSliders() {
    return FirebaseFirestore.instance
        .collection("Products")
        .where('prodIsOnSlider', isEqualTo: true)
        .get()
        .then(
          (value) => value.docs
              .map((product) => ProductModel.fromJson(product.data()))
              .toList(),
        );
    // .map(
    //   (sliders) => sliders.docs.map(
    //     (slider) => SliderModel.fromMap(
    //       slider.data(),
    //     ),
    //   ),
    // );
  }
}
