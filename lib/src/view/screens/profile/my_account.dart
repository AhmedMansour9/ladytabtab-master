import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ladytabtab/src/models/collection/app_collections.dart';
import '../../theme/palette.dart';
import '../main/main_screen.dart';

import '../../components/shared/custom_app_bar.dart';
import '../../components/shared/custom_material_button.dart';
import '../../components/shared/get_translated_data.dart';
import '../shipping/address_screen.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({
    Key? key,
    required this.fullName,
    required this.email,
    required this.mobile,
  }) : super(key: key);
  final String fullName;
  final String email;
  final String mobile;
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  late TextEditingController fullName, mobile;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fullName = TextEditingController(text: widget.fullName);
    // email = TextEditingController(text: widget.email);
    mobile = TextEditingController(text: widget.mobile);
  }

  @override
  void dispose() {
    fullName.dispose();
    // email.dispose();
    mobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizedBox = const SizedBox(height: 30);
    var theme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     child: const MainScreen(),
        //   ),
        //   (route) => false,
        // );
        return Future.value(true);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: getTranslatedData(context, "myAccount"),
          ctx: context,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 42,
            ),
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controllers: fullName,
                      hasIcon: false,
                    ),
                    sizedBox,
                    // CustomTextField(
                    //   controllers: email,
                    //   hasIcon: false,
                    // ),
                    // sizedBox,
                    CustomTextField(
                      hasIcon: false,
                      controllers: mobile,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9]'),
                        ),
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return getTranslatedData(context, "required");
                        } else if (!RegExp('^01[0125][0-9]{8}')
                            .hasMatch(value)) {
                          return "رقم هاتف غير صحيح";
                        } else {
                          return null;
                        }
                      },
                    ),
                    sizedBox,
                  ],
                ),
              ),
              sizedBox,
              CustomMaterialButton(
                color: Palette.primaryColor,
                child: Text(
                  getTranslatedData(context, 'save'),
                  style: theme.subtitle1!.copyWith(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await AppCollections.users.doc(currentUserUid).update({
                      "fullName": fullName.text,
                      "mobileNo": mobile.text,
                    }).then((value) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: "User data updated");
                      // Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const MainScreen();
                          },
                        ),
                        (route) => false,
                      );
                      // fullName.clear();
                      // mobile.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
