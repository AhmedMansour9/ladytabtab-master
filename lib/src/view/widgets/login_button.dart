import 'package:ladytabtab/exports_main.dart';

import '../../constants/routes/routes.dart';
import '../components/shared/screens_size.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Center(
      child: SizedBox(
        width: ScreenSize.screenWidth! * 0.70,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Palette.secondaryColor,
          ),
          onPressed: () async {
            Navigator.pushNamed(context, RoutesPaths.loginScreen);
          },
          child: const Text(
            "سجلي دخول واشتري دلوقتي",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
