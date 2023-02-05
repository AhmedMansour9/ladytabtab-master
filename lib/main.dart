import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ladytabtab/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:ladytabtab/src/blocs/auth_bloc/auth_event.dart';

import 'app.dart';
import 'exports_main.dart';
import 'firebase_options.dart';
import 'observer.dart';
import 'src/blocs/slider_bloc/sliderbloc_bloc.dart';
import 'src/lang_bloc/applanguage_bloc.dart';
import 'src/view/theme/app_theme.dart';

Future<void> _fbMsgBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'ladytabtab',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_fbMsgBackgroundHandler);

  StatusBarTheme.transparentStatusBar;
  await StatusBarTheme.portraitUpOnly;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('login');

  runApp(
    BlocOverrides.runZoned(
      () {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AppLangBloc>(
              create: (context) {
                return AppLangBloc();
              },
            ),
            BlocProvider<SliderBloc>(
              create: (context) {
                return SliderBloc();
              },
            ),
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc()..add(const AuthEventInit()),
            ),
          ],
          child: MyApp(
            email: email,
          ),
        );
      },
      blocObserver: MyBlocObserver(),
    ),
  );
}
