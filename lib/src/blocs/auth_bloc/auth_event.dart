import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {}

@immutable
class AuthEventInit implements AuthEvent {
  const AuthEventInit();
}

@immutable
class AuthEventLogIn implements AuthEvent {
  const AuthEventLogIn({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

@immutable
class AuthEventLogOut implements AuthEvent {
  const AuthEventLogOut();
}

@immutable
class AuthEventRegister implements AuthEvent {
  const AuthEventRegister({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;
}

  // End