import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:ladytabtab/src/models/user/user_model.dart';

@immutable
abstract class AuthState {
  const AuthState({required this.isLoading});

  final bool isLoading;
}

@immutable
class AuthInitial extends AuthState {
  const AuthInitial(bool isLoading) : super(isLoading: isLoading);
}

@immutable
class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn({required bool isLoading, required this.user})
      : super(isLoading: isLoading);

  // final UserModel user;
  final User? user;
}

@immutable
class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut({required bool isLoading})
      : super(isLoading: isLoading);
}

extension GetUser on AuthState {
  UserModel? get users {
    final authUser = this;
    if (this is AuthStateLoggedIn) {
      return authUser.users;
    } else {
      return null;
    }
  }
}
