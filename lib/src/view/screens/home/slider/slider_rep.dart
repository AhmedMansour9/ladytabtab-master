// import 'package:ladytabtab/exports_main.dart';
// import 'package:ladytabtab/src/view/screens/home/slider/slider_model.dart';

// class SliderRep {
//   SliderRep(this._firebaseFirestore);
//   final FirebaseFirestore _firebaseFirestore;

//   Stream<List<SliderModel>> _getSliders() {
//     return _firebaseFirestore
//         .collection("Products")
//         .where('prodIsOnSlider', isEqualTo: true)
//         .snapshots()
//         .map(
//           (sliders) => sliders.docs
//               .map(
//                 (slider) => SliderModel.fromMap(
//                   slider.data(),
//                 ),
//               )
//               .toList(),
//         );
//   }
// }
