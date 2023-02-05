import 'package:flutter_svg/flutter_svg.dart';

import '../../../exports_main.dart';
import '../../constants/routes/routes.dart';
import '../../models/collection/app_collections.dart';
import '../screens/auth/check_user_auth.dart';

class TopCartCounter extends StatefulWidget {
  const TopCartCounter({
    Key? key,
  }) : super(key: key);

  @override
  State<TopCartCounter> createState() => _TopCartCounterState();
}

class _TopCartCounterState extends State<TopCartCounter> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _quantityStream;

  @override
  void initState() {
    super.initState();
if(currentUser !=null) {
  _quantityStream = AppCollections.cart
      .where("userId", isEqualTo: currentUser!.uid)
      .snapshots();
}

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          splashRadius: 24,
          icon: SvgPicture.asset(
            kRoundedBag,
            color: Palette.blackColor,
          ),
          onPressed: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const CartScreen(),
            //   ),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckUserAuth(
                  currentScreenPath: RoutesPaths.mainScreens,
                ),
              ),
            );
          },
        ),
        // PLEASE ENDTER mohamed@gmail.com and password ١٢٣٤٥٦٧
        if (currentUser != null)
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _quantityStream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.docs.isNotEmpty) {
                return Positioned(
                  top: 3,
                  right: 5,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    margin: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE72626),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        snapshot.data!.docs.length.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.overline!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
      ],
    );
  }
}
