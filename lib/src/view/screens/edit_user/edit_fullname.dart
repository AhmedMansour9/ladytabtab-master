import 'package:ladytabtab/src/models/collection/app_collections.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';

import '../../components/custom_arrow_back.dart';

class EditFullName extends StatefulWidget {
  const EditFullName({Key? key}) : super(key: key);

  @override
  State<EditFullName> createState() => _EditFullNameState();
}

class _EditFullNameState extends State<EditFullName> {
  TextEditingController fullNameController = TextEditingController();

  String fullName = "";
  final String? currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedData(context, "change_full_name"),
        ),
        leading: CustomArrowBack(ctx: context),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 22),
              Text(
                getTranslatedData(context, "change_name_title"),
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 20),
              Form(
                child: SizedBox(
                  // width: ScreenSize.screenWidth! * 0.90,
                  height: 40,
                  child: TextFormField(
                    controller: fullNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: getTranslatedData(context, "enter_full_name"),
                    ),
                    onChanged: (val) {
                      setState(() {
                        fullName = val;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),
              // SUBMIT THE NEW FULLNAME
              SizedBox(
                width: ScreenSize.screenWidth! * 0.90,
                height: 48,
                child: ElevatedButton(
                  onPressed: fullNameController.text.isEmpty && fullName.isEmpty
                      ? null
                      : () async {
                          //TODO: UPDATE THE CURRENT USER FULLNAME BY UID
                          await AppCollections.users.doc(currentUserUid).update(
                            {"fullName": fullNameController.text},
                          ).then(
                            (value) {
                              Navigator.pop(context);
                              // Fluttertoast.cancel();
                              // Fluttertoast.showToast(
                              //     msg: "تم تحديث الإسم بنجاح!");
                            },
                          ).catchError((error) {
                            // Navigator.pop(context)
                          });
                        },
                  child: Text(
                    getTranslatedData(context, "update_button"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
