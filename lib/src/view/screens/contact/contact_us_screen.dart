import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/custom_arrow_back.dart';
import '../../components/shared/social_links.dart';
import '../../theme/palette.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/screens_size.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({
    Key? key,
  }) : super(key: key);

  static const route = '/contactUsScreen';

  @override
  ContactUsScreenState createState() => ContactUsScreenState();
}

class ContactUsScreenState extends State<ContactUsScreen> {
  final String _intro =
      "ليدي طبطب هو براند مصري تم تأسيسه عام 2018م، فكرته قائمة على الدمج بين حب الجمال المستوحى من الطبيعة وبين الثقافة العامة. فهو كيان متكامل يساعد المرأة على تقدير ذاتها من خلال مكافأتها من حين لآخر بروتين عناية صحي ومتكامل للجسم والبشرة مع دليل إرشادي منظم لنشر وترسيخ قواعد الإتيكيت ورفع المستوى. يدعم ليدي طبطب النساء أيضًا من خلال فرص عمل مريحة برواتب مجزية.";
  final _services =
      'عن طيبة حافظ:\n مؤسس البراند واستشاري تجميلي لعدة سنوات، تساعد الفتيات والسيدات على اختيار روتين العناية الخاص بهم باحترافية عن طريق مذاكرة المنتجات واستخدامها بشكل شخصي ومن ثم تحليلها وتقديم عصارة تجربتها.. وتكرس جهودها الآن في استخلاص وتركيب الزيوت الطبيعية النقية "النادرة".';
  final String title = 'رؤيتنا:';
  final String subtile =
      'صناعة مواد تجميلية نظيفة ومناسبة للبيئة وخالية من الكيماويات، صناعة مصرية على الطريقة الكورية تهدف إلى التصدير للخارج.';

  final String ladyEmail = "ladytabtab02@gmail.com";

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(phoneUri)) launchUrl(phoneUri);
    } catch (error) {
      throw ("Cannot dial");
    }
  }

  void _launchURL(String url) async => await canLaunchUrl(Uri.parse(url))
      ? await launchUrl(Uri.parse(url))
      : throw 'Could not launch $url';
  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: CustomArrowBack(ctx: context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 14.0),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 30,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50000),
                    child: Image.asset(
                      kLadyIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              // Social Media
              Center(
                child: SizedBox(
                  width: ScreenSize.screenWidth! * 0.33,
                  height: 33,
                  child: ElevatedButton(
                    onPressed: () {
                      _launchURL(SocialLinks.facebook);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Palette.elevationColor,
                      primary: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 3.0,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            facebookIcon,
                            height: 25.0,
                          ),
                          const SizedBox(width: 5.0),
                          const Text(
                            'فيسبوك',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xFF1977F2),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: ladyEmail))
                        .then((value) {
                      Fluttertoast.showToast(msg: "Copied to Clipboard");
                    });
                  },
                  child: Text(
                    ladyEmail,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.blue,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                indent: 50,
                endIndent: 50,
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _intro,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                child: Text(
                  _services,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                child: Text(
                  subtile,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              // const SizedBox(height: 15),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              //   child: Text(
              //     _help,
              //     textAlign: TextAlign.right,
              //     textDirection: TextDirection.rtl,
              //     style: textStyle,
              //   ),
              // ),

              // const SizedBox(height: 5),
              // Directionality(
              //   textDirection: TextDirection.rtl,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 3.0,
              //       horizontal: 20.0,
              //     ),
              //     child: Row(
              //       children: [
              //         Text(
              //           'موبايل:',
              //           textAlign: TextAlign.right,
              //           textDirection: TextDirection.rtl,
              //           style: textStyle,
              //         ),
              //         TextButton(
              //           onPressed: () {
              //             launchPhoneDialer(_mobileNo);
              //           },
              //           child: Text(
              //             _mobileNo,
              //             style:
              //                 Theme.of(context).textTheme.subtitle1!.copyWith(
              //                       color: Palette.primaryColor,
              //                     ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
