import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../view_models/user/orders_services.dart';
import '../../components/custom_progress_indicator.dart';
import '../../theme/palette.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';
import 'receipt.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    Key? key,
    required this.cityName,
    required this.orderNote,
  }) : super(key: key);
  final String cityName;
  final String orderNote;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool? cashSelected = true;
  bool? vfCashSelected = false;

  @override
  Widget build(BuildContext context) {
    UserOrdersServices userOrdersServices = UserOrdersServices();
    ScreenSize().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(getTranslatedData(context, "payment")),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: TextButton.styleFrom(
            primary: Palette.greyColor,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            minimumSize: size,
            maximumSize: size,
          ),
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
            // size: 24,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: ScreenSize.screenHeight,
          child: FutureBuilder<bool>(
            future: userOrdersServices.vodafoneCashPayment(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data == true) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: _PaymentMethod(
                        title: getTranslatedData(context, "vfCash"),
                        onChanged: (val) {
                          setState(() {
                            vfCashSelected = val;
                          });
                        },
                        isSelected: vfCashSelected,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptScreen(
                                cityName: widget.cityName,
                                userNote: widget.orderNote,
                                paymentVfCash:
                                    vfCashSelected == true ? true : false,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          getTranslatedData(context, "continue"),
                          // style: const TextStyle(
                          //   color: Palette.bgColor,
                          // ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                  ],
                );
              } else if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data == false) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: _PaymentMethod(
                        title: getTranslatedData(context, "cash"),
                        onChanged: (val) {
                          setState(() {
                            cashSelected = val;
                            if (cashSelected == true) {
                              vfCashSelected = false;
                            }
                          });
                        },
                        isSelected: cashSelected,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: _PaymentMethod(
                        title: getTranslatedData(context, "vfCash"),
                        onChanged: (val) {
                          setState(() {
                            vfCashSelected = val;
                            if (vfCashSelected == true) {
                              cashSelected = false;
                            }
                          });
                        },
                        isSelected: vfCashSelected,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReceiptScreen(
                                  cityName: widget.cityName,
                                  userNote: widget.orderNote,
                                  paymentVfCash:
                                      vfCashSelected == true ? true : false,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            getTranslatedData(context, "continue"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: _PaymentMethod(
                        title: getTranslatedData(context, "cash"),
                        onChanged: (val) {
                          setState(() {
                            cashSelected = val;
                            if (cashSelected == true) {
                              vfCashSelected = false;
                            }
                          });
                        },
                        isSelected: cashSelected,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: _PaymentMethod(
                        title: getTranslatedData(context, "vfCash"),
                        onChanged: (val) {
                          setState(() {
                            vfCashSelected = val;
                            if (vfCashSelected == true) {
                              cashSelected = false;
                            }
                          });
                        },
                        isSelected: vfCashSelected,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReceiptScreen(
                                  cityName: widget.cityName,
                                  userNote: widget.orderNote,
                                  paymentVfCash:
                                      vfCashSelected == true ? true : false,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            getTranslatedData(context, "continue"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }
              return const CustomProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class _PaymentMethod extends StatefulWidget {
  const _PaymentMethod({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final bool? isSelected;
  final void Function(bool?) onChanged;

  @override
  State<_PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<_PaymentMethod> {
  bool currentVal = true;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        // setState(() {
        widget.onChanged(currentVal);
        // });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          // color: Color(0xFF76CFAA),
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 33,
              color: Color(0xFFEBEBEB),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: theme.subtitle1,
            ),
            Radio(
              value: currentVal,
              groupValue: widget.isSelected,
              fillColor: MaterialStateProperty.all(Palette.primaryColor),
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
