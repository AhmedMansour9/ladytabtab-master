import 'package:ladytabtab/exports_main.dart';
import 'package:ladytabtab/src/view/screens/cart/cart_screen.dart';

class CheckUserAuth extends StatefulWidget {
  const CheckUserAuth({Key? key, required this.currentScreenPath})
      : super(key: key);
  final String currentScreenPath;

  @override
  State<CheckUserAuth> createState() => _CheckUserAuthState();
}

class _CheckUserAuthState extends State<CheckUserAuth> {
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser == null) {
      return const LoginScreen();
    } else {
      return const CartScreen();
    }
  }
}
