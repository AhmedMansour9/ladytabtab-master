import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/collection/app_collections.dart';
import '../../../models/user/user_address_model.dart';
import '../../components/custom_arrow_back.dart';
import '../../components/custom_progress_indicator.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';
import 'address_screen.dart';

class EditUserAddress extends StatefulWidget {
  const EditUserAddress({Key? key, required this.selectedAddressId})
      : super(key: key);
  static const route = '/editUserAddress';
  final String selectedAddressId;

  @override
  State<EditUserAddress> createState() => _EditUserAddressState();
}

class _EditUserAddressState extends State<EditUserAddress> {
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  late TextEditingController fullName,
      mobile,
      phone,
      landline,
      city,
      street,
      building,
      specialPlace;

  TextEditingController userNote = TextEditingController();

  String? selectedCity = '';
  bool initDone = false;

  Future<void> initialControllers() async {
    await AppCollections.users
        .doc(currentUserUid)
        .collection("Addresses")
        .doc(widget.selectedAddressId)
        .get()
        .then((value) {
      Map<String, dynamic>? data = value.data();
      UserAddressModel userAddress = UserAddressModel.fromJson(data!);
      fullName = TextEditingController(text: userAddress.fullName);
      mobile = TextEditingController(text: userAddress.mobileNo);
      phone = TextEditingController(text: userAddress.phoneNo);
      landline = TextEditingController(text: userAddress.landline);
      selectedCity = userAddress.city;
      street = TextEditingController(text: userAddress.streetName);
      building = TextEditingController(text: userAddress.buildingNumber);
      specialPlace = TextEditingController(text: userAddress.specialPlace);
      setState(() {
        initDone = true;
      });
    });
  }

  disposeControllers() {
    fullName.dispose();
    mobile.dispose();
    phone.dispose();
    landline.dispose();
    street.dispose();
    building.dispose();
    specialPlace.dispose();
  }

  clearControllers() {
    fullName.clear();
    mobile.clear();
    phone.clear();
    landline.clear();
    selectedCity = '';
    street.clear();
    building.clear();
    specialPlace.clear();
  }

  @override
  void initState() {
    super.initState();
    initialControllers();
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? isSelected = true;

  String? validateMe(String? value) {
    if (value == null || value.isEmpty) {
      return getTranslatedData(context, "required");
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox = const SizedBox(height: 17);
    ScreenSize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedData(context, "editAddress"),
        ),
        leading: CustomArrowBack(ctx: context),
      ),
      body: SafeArea(
        child: !initDone
            ? const CustomProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: ScreenSize.screenWidth! * 0.90,
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controllers: fullName,
                                validators: validateMe,
                                hintsText:
                                    getTranslatedData(context, "fullName"),
                                textCapitalizations: TextCapitalization.words,
                                prefixsIcon: SvgPicture.asset(
                                  kProfileMyAccount,
                                  color: const Color(0xFF626262),
                                  width: 17,
                                  height: 17,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              sizedBox,
                              // Test dropmenu
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: AppCollections.deliveryFees.snapshots(),
                                // stream: null,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.docs.isNotEmpty) {
                                    var docs = snapshot.data!.docs;
                                    return DropdownButtonFormField<String>(
                                      // underline: const SizedBox(),
                                      hint: selectedCity == null ||
                                              selectedCity == ''
                                          ?
                                          // Text(
                                          //     getTranslatedData(
                                          //       context,
                                          //       "selectCity",
                                          //     ),
                                          //     style: const TextStyle(
                                          //       color: Colors.black,
                                          //     ),
                                          //   )

                                          Row(
                                              children: [
                                                SvgPicture.asset(
                                                  kAddressIcon,
                                                  color:
                                                      const Color(0xFF626262),
                                                  width: 22,
                                                  height: 22,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  getTranslatedData(
                                                    context,
                                                    "selectCity",
                                                  ),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2,
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                SvgPicture.asset(
                                                  kAddressIcon,
                                                  color:
                                                      const Color(0xFF626262),
                                                  width: 22,
                                                  height: 22,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  selectedCity.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2,
                                                ),
                                              ],
                                            ),

                                      // Text(
                                      //     selectedCity.toString(),
                                      //     style: const TextStyle(
                                      //       color: Colors.black,
                                      //     ),
                                      //   ),
                                      onChanged: (val) {
                                        setState(() {
                                          selectedCity = val;
                                        });
                                      },
                                      items: docs.map((doc) {
                                        return DropdownMenuItem<String>(
                                          value: doc['cityName'].toString(),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                kAddressIcon,
                                                color: const Color(0xFF626262),
                                                width: 22,
                                                height: 22,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                '${doc['cityName']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),

                              sizedBox,
                              CustomTextField(
                                controllers: street,
                                validators: validateMe,
                                hintsText: getTranslatedData(context, "street"),
                                prefixsIcon: SvgPicture.asset(
                                  kAddressIcon,
                                  color: const Color(0xFF626262),
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              sizedBox,
                              CustomTextField(
                                controllers: building,
                                validators: validateMe,
                                hintsText:
                                    getTranslatedData(context, "building"),
                                prefixsIcon: SvgPicture.asset(
                                  kAddressIcon,
                                  color: const Color(0xFF626262),
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              sizedBox,
                              CustomTextField(
                                controllers: specialPlace,
                                validators: validateMe,
                                hintsText:
                                    getTranslatedData(context, "specialPlace"),
                                prefixsIcon: SvgPicture.asset(
                                  kAddressIcon,
                                  color: const Color(0xFF626262),
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              sizedBox,
                              CustomTextField(
                                controllers: mobile,
                                textInputType: TextInputType.number,
                                hintsText: getTranslatedData(context, "mobile"),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'),
                                  ),
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                validators: (value) {
                                  if (value == null || value.isEmpty) {
                                    return getTranslatedData(
                                      context,
                                      "required",
                                    );
                                  } else if (!RegExp('^01[0125][0-9]{8}')
                                      .hasMatch(value)) {
                                    return getTranslatedData(
                                      context,
                                      "wrongMobileNumber",
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                // mxLength: 11,
                                prefixsIcon: Center(
                                  child: Text(
                                    "+20",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          height: 0.81,
                                          color: const Color(0xFF626262),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              sizedBox,
                              CustomTextField(
                                controllers: phone,
                                textInputType: TextInputType.number,
                                hintsText: getTranslatedData(context, "phone"),
                                // mxLength: 11,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'),
                                  ),
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                validators: (val) {
                                  if (val != null &&
                                      val.isNotEmpty &&
                                      !RegExp('^01[0125][0-9]{8}')
                                          .hasMatch(val)) {
                                    return getTranslatedData(
                                      context,
                                      "wrongMobileNumber",
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                prefixsIcon: Center(
                                  child: Text(
                                    "+20",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          height: 0.81,
                                          color: const Color(0xFF626262),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              sizedBox,
                              CustomTextField(
                                controllers: landline,
                                // mxLength: 10,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'),
                                  ),
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                validators: (val) {
                                  if (val != null &&
                                      val.isNotEmpty &&
                                      !RegExp('^0[1-9][0-9]{8}')
                                          .hasMatch(val)) {
                                    return getTranslatedData(
                                      context,
                                      "wrongMobileNumber",
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                textInputType: TextInputType.number,
                                hintsText:
                                    getTranslatedData(context, "landline"),
                                prefixsIcon: Center(
                                  child: Text(
                                    "+20",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          height: 0.81,
                                          color: const Color(0xFF626262),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              sizedBox,
                            ],
                          ),
                        ),
                        sizedBox,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  selectedCity != null &&
                                  selectedCity!.isNotEmpty) {
                                UserAddressModel userAddressModel =
                                    UserAddressModel(
                                  addressDocId: "",
                                  fullName: fullName.text,
                                  mobileNo: mobile.text,
                                  phoneNo: phone.text,
                                  landline: landline.text,
                                  city: selectedCity,
                                  streetName: street.text,
                                  buildingNumber: building.text,
                                  specialPlace: specialPlace.text,
                                  mapAddress: null,
                                );
                                Map<String, dynamic> addressData =
                                    userAddressModel.toUpdate();
                                AppCollections.users
                                    .doc(currentUserUid)
                                    .collection("Addresses")
                                    .doc(widget.selectedAddressId)
                                    .update(
                                      addressData,
                                    )
                                    .then((value) {
                                  Navigator.of(context).pop(true);
                                  setState(() {
                                    clearControllers();
                                    selectedCity = '';
                                  });
                                });
                              }
                            },
                            child: Text(
                              getTranslatedData(context, "edit").toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
