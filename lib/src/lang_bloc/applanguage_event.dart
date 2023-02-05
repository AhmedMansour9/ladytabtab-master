part of 'applanguage_bloc.dart';

@immutable
abstract class LanguageEvent {}

class AppLangEvent extends LanguageEvent {
  final Locale appLocal;

  AppLangEvent({required this.appLocal});
}
