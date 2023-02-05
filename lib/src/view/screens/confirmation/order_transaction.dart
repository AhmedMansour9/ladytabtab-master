import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/routes/routes.dart';
import '../../../view_models/user/cart_services.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';

class OrderTransaction extends StatefulWidget {
  const OrderTransaction({Key? key}) : super(key: key);

  @override
  State<OrderTransaction> createState() => _OrderTransactionState();
}

class _OrderTransactionState extends State<OrderTransaction> {
  late CartServices cartServices;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      cartServices = CartServices();
      cartServices.clearCart();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    ScreenSize().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: ScreenSize.screenWidth,
          height: ScreenSize.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 50),
              SvgPicture.asset(
                kTransactionIcon,
                height: 200,
              ),
              Text(
                getTranslatedData(context, "orderSuccess"),
                style: textTheme.headline6!.copyWith(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                getTranslatedData(context, "successMessage"),
                textAlign: TextAlign.center,
                style: textTheme.subtitle1!.copyWith(height: 1.5),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesPaths.mainScreens,
                        (route) => false,
                      );
                    });
                  },
                  child: Text(
                    getTranslatedData(context, "backToHome"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
