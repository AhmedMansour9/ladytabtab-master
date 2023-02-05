import 'package:bloc/bloc.dart';
import 'package:ladytabtab/exports_main.dart';

part 'applanguage_event.dart';
part 'applanguage_state.dart';

class AppLangBloc extends Bloc<LanguageEvent, AppLangState> {
  AppLangBloc()
      : super(
          AppLangState(
            appLocal: const Locale('ar'),
          ),
        ) {
    on<AppLangEvent>((event, emit) {
      emit(AppLangState(appLocal: event.appLocal));
    });
  }
}
