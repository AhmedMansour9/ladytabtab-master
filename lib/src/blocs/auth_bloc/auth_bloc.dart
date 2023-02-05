import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial(false)) {
    on<AuthEvent>((event, emit) {});
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(isLoading: true));
      // log the user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "AASDF",
          password: "546446fsad64",
        );
        final user = userCredential.user;
        emit(
          AuthStateLoggedIn(
            isLoading: false,
            user: user,
          ),
        );
      } catch (error) {
        emit(const AuthStateLoggedOut(isLoading: false));
      }
    });
    on<AuthEventLogOut>((event, emit) {});
    on<AuthEventRegister>((event, emit) {});
  }
}
