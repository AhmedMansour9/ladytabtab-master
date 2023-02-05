import 'package:ladytabtab/exports_main.dart';
import 'package:ladytabtab/src/view/components/custom_arrow_back.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../models/collection/app_collections.dart';

enum Status { waiting, error }

class UpdateMobileNoScreen extends StatefulWidget {
  const UpdateMobileNoScreen({Key? key}) : super(key: key);

  // static const route = 'UpdateMobileNoScreenNo';

  @override
  State<UpdateMobileNoScreen> createState() => UpdateMobileNoScreenState();
}

class UpdateMobileNoScreenState extends State<UpdateMobileNoScreen> {
  late TextEditingController _phoneNumber;

  @override
  void initState() {
    super.initState();
    _phoneNumber = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslatedData(context, "change_phone_number")),
        leading: CustomArrowBack(ctx: context),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 30),
                    // Title
                    Text(
                      getTranslatedData(context, "change_your_phone_number"),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                    Text(
                      getTranslatedData(context, "verification_code_title"),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: SizedBox(
                        width: ScreenSize.screenWidth! * 0.95,
                      ),
                    ),

                    SizedBox(
                      width: ScreenSize.screenWidth! * 0.95,
                      child: TextFormField(
                        controller: _phoneNumber,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.left,
                        // cursorHeight: 20,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9]'),
                          ),
                        ],
                        style: const TextStyle(
                          color: Colors.black,
                          letterSpacing: 12,
                        ),
                        decoration: const InputDecoration(
                          // contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintText: "01012345678",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: ScreenSize.screenWidth! * 0.90,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerificationNumberScreen(
                            mobileNumber: "+2${_phoneNumber.text}",
                          ),
                        ),
                      );
                    },
                    child: Text(
                      getTranslatedData(context, "update_button"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationNumberScreen extends StatefulWidget {
  const VerificationNumberScreen({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);
  final String mobileNumber;
  @override
  VerificationNumberScreenState createState() =>
      VerificationNumberScreenState();
}

class VerificationNumberScreenState extends State<VerificationNumberScreen> {
  Status _status = Status.waiting;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  Future _verifyPhoneNumber() async {
    _auth.verifyPhoneNumber(
      phoneNumber: widget.mobileNumber,
      verificationCompleted: (phonesAuthCredentials) async {},
      verificationFailed: (verificationFailed) async {},
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _status != Status.error
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  getTranslatedData(context, "verification_code_title_sent"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Palette.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.mobileNumber.isEmpty || widget.mobileNumber == ""
                      ? ""
                      : widget.mobileNumber,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Palette.secondaryColor,
                        letterSpacing: 5,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                      backgroundColor: Colors.transparent,
                      appContext: context,
                      length: 6,
                      animationType: AnimationType.scale,
                      onChanged: (val) async {
                        if (val.length == 6) {
                          try {
                            PhoneAuthProvider.credential(
                              verificationId: _verificationId!,
                              smsCode: val.trim(),
                            );

                            // TODO: issue related to users address.
                            if (val.length == 6) {
                              User? currentUser =
                                  FirebaseAuth.instance.currentUser;

                              await AppCollections.users
                                  .doc(currentUser!.uid)
                                  .update({"mobileNo": widget.mobileNumber});
                            }
                            if (!mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainScreen(),
                              ),
                              (route) => false,
                            );
                          } catch (error) {
                            debugPrint("I am full error: $error end");
                          }
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 0.7,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        fieldWidth: 42,
                        fieldHeight: 42,
                        activeColor: Palette.primaryColor,
                        activeFillColor: Palette.primaryColor,
                        selectedColor: Palette.secondaryColor,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslatedData(context, "didnt_received")),
                    TextButton(
                      child: Text(getTranslatedData(context, "send_again")),
                      onPressed: () async {
                        setState(() {
                          _status = Status.waiting;
                        });
                        _verifyPhoneNumber();
                      },
                    )
                  ],
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "OTP Verification",
                    style: TextStyle(
                      color: const Color(0xFF08C187).withOpacity(0.7),
                      fontSize: 30,
                    ),
                  ),
                ),
                const Text("The code used is invalid!"),
                TextButton(
                  child: const Text("Edit Number"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Resend Code"),
                  onPressed: () async {
                    setState(() {
                      _status = Status.waiting;
                    });

                    _verifyPhoneNumber();
                  },
                ),
              ],
            ),
    );
  }
}
