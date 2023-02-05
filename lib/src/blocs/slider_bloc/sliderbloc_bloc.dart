import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../models/product/product_model.dart';

part 'sliderbloc_event.dart';
part 'sliderbloc_state.dart';

class SliderBloc extends Bloc<SliderBllocEvent, SliderblocState> {
  SliderBloc() : super(SliderDataState()) {
    on<SliderBllocEvent>((event, emit) {
      emit(SliderDataState());
    });
  }
}
