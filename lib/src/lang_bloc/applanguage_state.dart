part of 'applanguage_bloc.dart';

@immutable
abstract class AppLanguageState {}

class AppLangState extends AppLanguageState {
  AppLangState({required this.appLocal});
  final Locale appLocal;

  // factory AppLangState.initial() {
  //   return AppLangState(appLocal: const Locale('ar'));
  // }

  static Future<void> changeLanguage(
    BuildContext context,
    Locale locale,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("langs") == null) {
      preferences.setString("langs", locale.languageCode);
    } else {
      preferences.setString("langs", locale.languageCode);
    }
  }
}
