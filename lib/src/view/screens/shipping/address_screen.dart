import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ladytabtab/exports_main.dart';

import '../../../models/collection/app_collections.dart';
import '../../../models/user/user_address_model.dart';
import '../../components/custom_arrow_back.dart';
import '../../components/custom_progress_indicator.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';
import '../../widgets/custom_progress_dialog.dart';
import 'payment.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({
    Key? key,
    required this.hasButton,
    this.mapAddress,
  }) : super(key: key);

  static const String route = '/addressScreen';

  final bool hasButton;
  final String? mapAddress;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  late TextEditingController fullName,
      mobile,
      phone,
      landline,
      city,
      street,
      building,
      specialPlace;
  SizedBox sizedBox = const SizedBox(height: 17);

  late bool isUserHasAddress;
  Map<String, dynamic> userAddressData = {};

  // List<Marker> _markers = [];
  // late LatLng currentLatLng;
  // late CameraPosition initialCameraPosition;
  // Location location = Location();
  // late LocationData _location;
  // late LocationData _locationResult;
  // String currentAddress = "";
  // // String mapAddress = "";

  TextEditingController userNote = TextEditingController();

  String? selectedCity = '';
  // Future<LocationData> _getLocation() async {
  //   _locationResult = await location.getLocation();
  //   setState(() {
  //     _location = _locationResult;
  //   });
  //   return _location;
  // }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? isSelected = true;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = AppCollections.users
        .doc(currentUserUid)
        .collection("Addresses")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedData(context, "myAddress"),
        ),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            primary: Palette.greyColor,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            minimumSize: size,
            maximumSize: size,
          ),
          child: const Icon(
            CupertinoIcons.back,
            color: Palette.blackColor,
            // size: 24,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            //TODO: BUILD ADD NEW ADDRESS BUTTON
            SizedBox(
              width: ScreenSize.screenWidth! * 0.50,
              // padding: EdgeInsets.symmetric(horizontal: 10),

              child: const _AddNewAddressButton(),
            ),
            const SizedBox(height: 7),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            snapshot.data!.docs[index].data();
                        UserAddressModel userAddressModel =
                            UserAddressModel.fromJson(data);
                        bool? isMainAddress = userAddressModel.isMainAddress;
                        return _AddressDetailsCard(
                          addressModel: userAddressModel,
                        );
                      },
                    );
                  } else if (snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    // return const _AddNewAddressButton();
                    return Center(
                      child: Text(
                        // "There are no address!\nAdd now your address...",
                        getTranslatedData(context, "noAddress"),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
                  }
                  return const CustomProgressIndicator();
                },
              ),
            ),
            // CHECKOUT BUTTON
            if (widget.hasButton)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await AppCollections.users
                            .doc(currentUserUid)
                            .collection("Addresses")
                            .where("isMainAddress", isEqualTo: true)
                            .get()
                            .then((value) {
                          var data = value.docs.first.get('city');
                          if (data != null) {
                            setState(() {
                              selectedCity = data;
                            });
                          }
                        }).then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                cityName: selectedCity!,
                                orderNote: userNote.text,
                              ),
                            ),
                          ).then((value) {
                            setState(() {
                              // clearControllers();
                              isUserHasAddress = true;
                              selectedCity = '';
                            });
                          });
                        });
                      } catch (error) {
                        Fluttertoast.cancel();
                        Fluttertoast.showToast(
                          msg: "Please, select your address!",
                        );
                      }
                    },
                    child: Text(
                      getTranslatedData(context, "shipping").toUpperCase(),
                    ),
                  ),
                ),
              ),

            if (widget.hasButton) const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.prefixsIcon,
    this.controllers,
    this.validators,
    this.textInputType,
    this.hintsText,
    this.textCapitalizations = TextCapitalization.none,
    this.hasIcon = true,
    this.initialText,
    this.inputFormatters,
    this.mxLength,
  }) : super(key: key);

  final Widget? prefixsIcon;
  final TextEditingController? controllers;

  final FormFieldValidator<String>? validators;
  final TextInputType? textInputType;
  final String? hintsText;
  final TextCapitalization textCapitalizations;
  final bool hasIcon;
  final String? initialText;
  final List<TextInputFormatter>? inputFormatters;
  final int? mxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllers,
      initialValue: initialText,
      textAlignVertical: TextAlignVertical.center,
      validator: validators,
      keyboardType: textInputType,
      textCapitalization: textCapitalizations,
      inputFormatters: inputFormatters,
      maxLength: mxLength,
      decoration: InputDecoration(
        contentPadding: hasIcon
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 5,
              ),
        prefixIcon: hasIcon
            ? Container(
                alignment: Alignment.center,
                width: 52,
                height: 25,
                // margin: const EdgeInsets.symmetric(
                //   vertical: 14,
                //   horizontal: 12,
                // ),
                child: prefixsIcon,
              )
            : null,
        hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Palette.greyColor,
            ),
        hintText: hintsText,
      ),
    );
  }
}

class _AddNewAddressButton extends StatelessWidget {
  const _AddNewAddressButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Palette.blueColor,

        // shape: const RoundedRectangleBorder(
        //   borderRadius: Radiuz.smallRadius,
        // ),
        // side: BorderSide(
        //   color: Colors.grey.shade300,
        // ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const _AddNewAddressWidget(),
          ),
        );
      },
      label: Text(
        getTranslatedData(context, "addNewAddress"),
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Colors.white,
            ),
      ),
      icon: const Icon(
        Icons.add,
        color: Palette.whiteColor,
        size: 17,
      ),
    );
  }
}

class _AddressDetailsCard extends StatefulWidget {
  const _AddressDetailsCard({Key? key, required this.addressModel})
      : super(key: key);

  final UserAddressModel addressModel;

  @override
  State<_AddressDetailsCard> createState() => _AddressDetailsCardState();
}

class _AddressDetailsCardState extends State<_AddressDetailsCard> {
  @override
  Widget build(BuildContext context) {
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    UserAddressServices userAddressServices = UserAddressServices();
    return GestureDetector(
      onTap: () async {
        await AppCollections.users
            .doc(currentUserUid)
            .collection("Addresses")
            .get()
            .then((value) {
          for (var doc in value.docs) {
            if (doc.id == widget.addressModel.addressDocId &&
                widget.addressModel.isMainAddress == false) {
              setState(() {
                AppCollections.users
                    .doc(currentUserUid)
                    .collection("Addresses")
                    .doc(doc.id)
                    .update({'isMainAddress': true});
              });
            } else {
              setState(() {
                AppCollections.users
                    .doc(currentUserUid)
                    .collection("Addresses")
                    .doc(doc.id)
                    .update({'isMainAddress': false});
              });
            }
          }

          //     .collection("Users")
          //     .doc(currentUserUid)
          //     .collection("Addresses")
          //     .doc(widget.addressModel.addressDocId)
          //     .update({'isMainAddress': true});
        });
      },
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 14,
            ),
            elevation: 0.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.1,
                color: widget.addressModel.isMainAddress!
                    ? Palette.primaryColor
                    : const Color(0xFFEEEFFE),
              ),
              borderRadius: Radiuz.mediumRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${getTranslatedData(context, "fullName")}: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                              color: Colors.black,
                                            ),
                                      ),
                                      Text(
                                        '${widget.addressModel.fullName}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                              color: Colors.grey.shade600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  RichText(
                                    text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                      children: [
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                          text:
                                              "${getTranslatedData(context, "myAddress")}: ",
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.addressModel.buildingNumber} ",
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.addressModel.streetName}، ",
                                        ),
                                        TextSpan(
                                          text: "${widget.addressModel.city} ",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const Divider(),
                  // Map address
                  // Text(
                  //   widget.addressModel.mapAddress.toString(),
                  // ),
                  const SizedBox(height: 20),
                  // Delete address button
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio(
                            fillColor: MaterialStateProperty.all(
                              // Colors.green,
                              Palette.primaryColor,
                            ),
                            value: widget.addressModel.isMainAddress ?? false,
                            groupValue: true,
                            onChanged: (bool? val) async {
                              await AppCollections.users
                                  .doc(currentUserUid)
                                  .collection("Addresses")
                                  .get()
                                  .then((value) {
                                for (var doc in value.docs) {
                                  if (doc.id ==
                                          widget.addressModel.addressDocId &&
                                      widget.addressModel.isMainAddress ==
                                          false) {
                                    setState(() {
                                      AppCollections.users
                                          .doc(currentUserUid)
                                          .collection("Addresses")
                                          .doc(doc.id)
                                          .update({'isMainAddress': true});
                                    });
                                  } else {
                                    setState(() {
                                      AppCollections.users
                                          .doc(currentUserUid)
                                          .collection("Addresses")
                                          .doc(doc.id)
                                          .update({'isMainAddress': false});
                                    });
                                  }
                                }

                                //     .collection("Users")
                                //     .doc(currentUserUid)
                                //     .collection("Addresses")
                                //     .doc(widget.addressModel.addressDocId)
                                //     .update({'isMainAddress': true});
                              });
                            },
                          ),
                          if (widget.addressModel.isMainAddress ?? false)
                            const Text("عنوان رئيسي")
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFFEFEFE),
                            padding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 14,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: Radiuz.largeRadius,
                              side: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            // elevation: 0.5,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              EditUserAddress.route,
                              arguments: widget.addressModel.addressDocId,
                            );
                          },
                          child: Text(
                            getTranslatedData(context, "edit"),
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 30,
            child: Material(
              child: InkWell(
                onTap: () {
                  // TODO: delete/make null user address...
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          getTranslatedData(
                            context,
                            "delete_address_title",
                          ),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              userAddressServices
                                  .deleteUserAddressById(
                                    currentUserUid,
                                    widget.addressModel.addressDocId!,
                                  )
                                  .then(
                                    (value) => Navigator.pop(context),
                                  )
                                  .catchError((error) {
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              getTranslatedData(context, "yes"),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              getTranslatedData(context, "no"),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 235, 46, 46),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddNewAddressWidget extends StatefulWidget {
  const _AddNewAddressWidget({Key? key}) : super(key: key);

  @override
  State<_AddNewAddressWidget> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<_AddNewAddressWidget> {
  // ALL VARIABLES

  late TextEditingController fullName,
      mobile,
      phone,
      landline,
      city,
      street,
      building,
      specialPlace;
  SizedBox sizedBox = const SizedBox(height: 17);

  late bool isUserHasAddress;
  Map<String, dynamic> userAddressData = {};

  // List<Marker> _markers = [];
  // late LatLng currentLatLng;
  // late CameraPosition initialCameraPosition;
  // Location location = Location();
  // late LocationData _location;
  // late LocationData _locationResult;
  String currentAddress = "";
  // String mapAddress = "";

  TextEditingController userNote = TextEditingController();

  String? selectedCity = '';
  // Future<LocationData> _getLocation() async {
  //   _locationResult = await location.getLocation();
  //   setState(() {
  //     _location = _locationResult;
  //   });
  //   return _location;
  // }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? isSelected = true;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _deliveryStream;

  String? _validateMe(String? value) {
    if (value == null || value.isEmpty) {
      return getTranslatedData(context, "required");
    } else {
      return null;
    }
  }

  initialControllers() {
    fullName = TextEditingController();
    mobile = TextEditingController();
    phone = TextEditingController();
    landline = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    building = TextEditingController();
    specialPlace = TextEditingController();
  }

  disposeControllers() {
    fullName.dispose();
    mobile.dispose();
    phone.dispose();
    landline.dispose();
    city.dispose();
    street.dispose();
    building.dispose();
    specialPlace.dispose();
  }

  clearControllers() {
    fullName.clear();
    mobile.clear();
    phone.clear();
    landline.clear();
    city.clear();
    street.clear();
    building.clear();
    specialPlace.clear();
  }

  @override
  void initState() {
    super.initState();
    initialControllers();
    _deliveryStream = AppCollections.deliveryFees.snapshots();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        leading: CustomArrowBack(ctx: context),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                getTranslatedData(context, "shippingData"),
                style: Theme.of(context).textTheme.subtitle2,
              ),
              sizedBox,

              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controllers: fullName,
                      validators: _validateMe,
                      hintsText: getTranslatedData(context, "fullName"),
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
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _deliveryStream,
                      // stream: null,
                      builder: (context, snapshot) {
                        debugPrint("## Streams - Add new address screen ##");
                        if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.docs.isNotEmpty) {
                          var docs = snapshot.data!.docs;
                          return DropdownButtonFormField<String>(
                            icon: const Icon(Icons.keyboard_arrow_down),

                            hint: Row(
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
                                  getTranslatedData(
                                    context,
                                    "selectCity",
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                              ],
                            ),

                            // Text(
                            //   getTranslatedData(
                            //     context,
                            //     "selectCity",
                            //   ),
                            //   style:
                            //       Theme.of(context).textTheme.subtitle2!.copyWith(
                            //             color: Colors.black,
                            //           ),
                            // ),
                            onChanged: (val) {
                              setState(() {
                                selectedCity = val;
                              });
                            },
                            onTap: () {},
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
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
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
                      validators: _validateMe,
                      textCapitalizations: TextCapitalization.words,
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
                      validators: _validateMe,
                      textCapitalizations: TextCapitalization.words,
                      hintsText: getTranslatedData(context, "building"),
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
                      validators: _validateMe,
                      textCapitalizations: TextCapitalization.words,
                      hintsText: getTranslatedData(context, "specialPlace"),
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
                          return getTranslatedData(
                            context,
                            "required",
                          );
                        } else if (!RegExp('^01[0125][0-9]{8}')
                            .hasMatch(value)) {
                          return "رقم هاتف غير صحيح";
                        } else {
                          return null;
                        }
                      },
                      // mxLength: 11,
                      textInputType: TextInputType.number,
                      hintsText: getTranslatedData(context, "mobile"),
                      prefixsIcon: Center(
                        child: Text(
                          "+20",
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
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
                      // mxLength: 11,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9]'),
                        ),
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      validators: (val) {
                        if (val != null &&
                            val.isNotEmpty &&
                            !RegExp('^01[0125][0-9]{8}').hasMatch(val)) {
                          return "رقم هاتف غير صحيح";
                        } else {
                          return null;
                        }
                      },
                      textInputType: TextInputType.number,
                      hintsText: getTranslatedData(context, "phone"),
                      prefixsIcon: Center(
                        child: Text(
                          "+20",
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
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
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      validators: (val) {
                        if (val != null &&
                            val.isNotEmpty &&
                            !RegExp('^0[1-9][0-9]').hasMatch(val)) {
                          return "الرقم الأرضي غير صحيح";
                        } else {
                          return null;
                        }
                      },
                      textInputType: TextInputType.number,
                      hintsText: getTranslatedData(context, "landline"),
                      prefixsIcon: Center(
                        child: Text(
                          "+20",
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
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
                  style: ElevatedButton.styleFrom(
                    primary: Palette.blueColor,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        selectedCity != null &&
                        selectedCity!.isNotEmpty) {
                      buildCustomShowDialog(context);
                      final userAddressId = AppCollections.users
                          .doc(currentUserUid)
                          .collection("Addresses")
                          .doc()
                          .id;
                      UserAddressModel userAddress = UserAddressModel(
                        addressDocId: userAddressId,
                        fullName: fullName.text,
                        mobileNo: mobile.text,
                        phoneNo: phone.text,
                        landline: landline.text,
                        city: selectedCity,
                        streetName: street.text,
                        buildingNumber: building.text,
                        specialPlace: specialPlace.text,
                        mapAddress: "widget.mapAddress",
                      );

                      // TODO: check if the user data saved in firesotre.
                      // TODO: check if the user data exists
                      // TODO: now save the new address in the user firestore
                      Map<String, dynamic> addressData = userAddress.toMap();
                      AppCollections.users
                          .doc(currentUserUid)
                          .get()
                          .then((docs) async {
                        if (docs.exists) {
                          await AppCollections.users
                              .doc(currentUserUid)
                              .collection("Addresses")
                              .doc(userAddressId)
                              .set(addressData)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: const Text(
                                  "حدث خطأ ما، سجلي خروج من التطبيق وحاولي  مرة أخرى",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "حسنا",
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    getTranslatedData(context, "add_address").toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Palette.whiteColor,
                        ),
                  ),
                ),
              ),

              sizedBox, sizedBox,
              // End class
            ],
          ),
        ),
      ),
    );
  }
}
