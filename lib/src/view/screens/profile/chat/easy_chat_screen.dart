import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path/path.dart';

import '../../../../models/collection/app_collections.dart';
import '../../../../view_models/user/chats_services.dart';
import '../../../components/custom_progress_indicator.dart';
import '../../../components/shared/auto_direction.dart';
import '../../../components/shared/custom_app_bar.dart';
import '../../../components/shared/get_translated_data.dart';
import '../../../components/shared/screens_size.dart';
import '../../../widgets/view_image.dart';

class EasyChatScreen extends StatefulWidget {
  const EasyChatScreen({
    Key? key,
  }) : super(key: key);

  static const route = 'easyChatScreen';

  @override
  EasyChatScreenState createState() => EasyChatScreenState();
}

class EasyChatScreenState extends State<EasyChatScreen> {
  late TextEditingController _content;
  User? currentUser = FirebaseAuth.instance.currentUser;

  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  File? imageFile;
  String? imageUrl;
  String? fileName;

  bool isScrollEnd = true;

  double _minHeightSize = 45.0;
  int numLines = 0;

  String formatsTime(Timestamp timeStamp) {
    var myDate = DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return intl.DateFormat('dd-MM hh:mm a').format(myDate);
  }

  Future _openImgPicker(
    BuildContext context, {
    required ImageSource imageSource,
  }) async {
    ImagePicker imagePicker = ImagePicker();
    // PickedFile? pickedFile;
    XFile? pickedFile;
    // pickedFile = await imagePicker.getImage(source: imageSource);
    pickedFile = await imagePicker.pickImage(source: imageSource);
    if (pickedFile != null) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        imageUrl = pickedFile!.path;
        imageFile = File(imageUrl!);
        fileName = basename(pickedFile.path);
      });
      final reference =
          FirebaseStorage.instance.ref().child('Chats').child('$fileName');

      UploadTask uploadTask = reference.putFile(imageFile!);
      uploadTask.then((val) {});

      try {
        TaskSnapshot snapshot = await uploadTask;

        imageUrl = await snapshot.ref.getDownloadURL();
        ChatServices chatServices = ChatServices();
        chatServices
            .setNewMessage(
          userId: currentUser!.uid,
          content: imageUrl ?? _content.text,
          contentType: imageUrl == null ? 0 : 1,
          sentByUser: true,
          isRead: false,
          time: Timestamp.fromDate(
            DateTime.now(),
          ),
        )
            .then((value) {
          _content.clear();
        });

        setState(() {});
      } on FirebaseException catch (e) {
        setState(() {
          // isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  @override
  void initState() {
    super.initState();
    _content = TextEditingController();
    listScrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (listScrollController.offset <
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        isScrollEnd = false;
      });
    }
    if (listScrollController.offset - 500 <
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        isScrollEnd = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: CustomAppBar(
        title: getTranslatedData(context, "chatTitle"),
        ctx: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: AppCollections.chats
                    .where('userId', isEqualTo: currentUser!.uid)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  debugPrint("## Streams - LiveChat Screen ##");
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      final docs = snapshot.data!.docs;
                      return Stack(
                        children: [
                          ListView.builder(
                            controller: listScrollController,
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: docs.length,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            itemBuilder: (BuildContext context, int index) {
                              var doc = docs[index];
                              final isMe = doc.data()['sentByUser'] ?? true;
                              final contentType =
                                  doc.data()['contentType'] ?? 0;
                              final textContent = doc.data()['content'];
                              final imgUrl = doc.data()['content'];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 3.0,
                                ),
                                child: contentType == 0
                                    ? Column(
                                        children: [
                                          const SizedBox(height: 7.0),
                                          GestureDetector(
                                            onLongPress: () {},
                                            child: Align(
                                              alignment: isMe
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: Container(
                                                // alignment: Alignment.center,
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      ScreenSize.screenWidth! *
                                                          0.60,
                                                  minWidth:
                                                      ScreenSize.screenWidth! *
                                                          0.30,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 14.0,
                                                  vertical: 5.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: isMe
                                                      ? const LinearGradient(
                                                          colors: [
                                                            Color.fromARGB(
                                                              255,
                                                              234,
                                                              236,
                                                              255,
                                                            ),
                                                            Color.fromARGB(
                                                              255,
                                                              221,
                                                              225,
                                                              255,
                                                            ),
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        )
                                                      : const LinearGradient(
                                                          colors: [
                                                            Color.fromARGB(
                                                              255,
                                                              209,
                                                              255,
                                                              243,
                                                            ),
                                                            Color.fromARGB(
                                                              255,
                                                              177,
                                                              247,
                                                              230,
                                                            ),
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                  borderRadius: isMe
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                            12.0,
                                                          ),
                                                          topRight:
                                                              Radius.circular(
                                                            12.0,
                                                          ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                            12.0,
                                                          ),
                                                        )
                                                      : const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                            12.0,
                                                          ),
                                                          topLeft:
                                                              Radius.circular(
                                                            12.0,
                                                          ),
                                                          bottomRight:
                                                              Radius.circular(
                                                            12.0,
                                                          ),
                                                        ),
                                                ),
                                                child: isMe
                                                    ? AutoDirection(
                                                        text:
                                                            '${doc.data()['content']}'
                                                                .toString(),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          // crossAxisAlignment:
                                                          //     CrossAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AutoDirection(
                                                                    text: '${doc.data()['content']}'
                                                                        .toString(),
                                                                    child: Text(
                                                                      '${doc.data()['content']}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Colors
                                                                            .black87,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 7.0,
                                                                  ),
                                                                  // Date & time
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        formatsTime(
                                                                          doc.data()[
                                                                              'time'],
                                                                        ),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              11.0,
                                                                          color:
                                                                              Colors.black38,
                                                                        ),
                                                                      ),
                                                                      if (docs
                                                                          .first
                                                                          .data()['isRead'])
                                                                        const Icon(
                                                                          Icons
                                                                              .check,
                                                                          size:
                                                                              14,
                                                                          color:
                                                                              Color.fromARGB(
                                                                            255,
                                                                            23,
                                                                            142,
                                                                            84,
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : AutoDirection(
                                                        text: '$textContent'
                                                            .toString(),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AutoDirection(
                                                                    text: '$textContent'
                                                                        .toString(),
                                                                    child: Text(
                                                                      '$textContent',
                                                                      // textAlign:
                                                                      //     TextAlign
                                                                      //         .right,
                                                                      // textDirection:
                                                                      //     TextDirection
                                                                      //         .rtl,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 7.0,
                                                                  ),
                                                                  Text(
                                                                    formatsTime(
                                                                      doc.data()[
                                                                          'time'],
                                                                    ),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          11.0,
                                                                      color: Colors
                                                                          .black38,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ViewImage(
                                                  imageUrl: imgUrl,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 250,
                                            padding: const EdgeInsets.all(7),
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                    255,
                                                    234,
                                                    236,
                                                    255,
                                                  ),
                                                  Color.fromARGB(
                                                    255,
                                                    221,
                                                    225,
                                                    255,
                                                  ),
                                                  // Color(0xFFB5F0BE),
                                                  // Color(0xFFB5F0BE),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              color: Color.fromARGB(
                                                255,
                                                235,
                                                242,
                                                247,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                  12.0,
                                                ),
                                                topLeft: Radius.circular(
                                                  12.0,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  12.0,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(12.0),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imgUrl,
                                                    // fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  formatsTime(
                                                    doc.data()['time'],
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 5,
                            left: 0,
                            right: 0,
                            child: isScrollEnd
                                ? const SizedBox()
                                : Center(
                                    child: RawMaterialButton(
                                      fillColor: const Color(0xFFF9F9F9),
                                      shape: const CircleBorder(),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onPressed: () {
                                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                                          listScrollController.animateTo(
                                            listScrollController
                                                .position.minScrollExtent,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: const Icon(
                                        Icons.arrow_downward,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    } else {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          const SizedBox(height: 50.0),
                          UnconstrainedBox(
                            child: SvgPicture.asset(
                              'assets/images/svg/chat.svg',
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                              color: const Color(0xFFFFC956),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'إحنا دايمًا معاكي .. تقدري تتواصلي معانا\nدلوقتي من خلال الشات',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.grey,
                                      height: 1.7,
                                    ),
                          ),
                        ],
                      );
                    }
                  }

                  return const CustomProgressIndicator();
                },
              ),
            ),
            SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                constraints: BoxConstraints(
                  minHeight: _minHeightSize,
                  maxHeight: 150,
                ),
                width: ScreenSize.screenWidth,
                padding: const EdgeInsets.only(top: 3, bottom: 3),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 239, 239, 239),
                ),
                child: Directionality(
                  textDirection:
                      isRTL(getTranslatedData(context, "typeMessage"))
                          ? TextDirection.ltr
                          : TextDirection.ltr,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: _minHeightSize > 45.0 || numLines > 1
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10.0),
                      RawMaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) {
                              return SafeArea(
                                child: Container(
                                  height: 170,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 50.0,
                                        // color: Colors.red,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'اختر صورة',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      // Spacer(),
                                      Column(
                                        children: [
                                          Material(
                                            child: InkWell(
                                              onTap: () => _openImgPicker(
                                                context,
                                                imageSource: ImageSource.camera,
                                              ).then((value) {
                                                // Navigator.pop(context);
                                              }),
                                              child: SizedBox(
                                                height: 60.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'الكاميرا',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Icon(Icons.camera_alt),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Material(
                                            child: InkWell(
                                              onTap: () => _openImgPicker(
                                                context,
                                                imageSource:
                                                    ImageSource.gallery,
                                              ).then((value) {
                                                // Navigator.pop(context);
                                              }),
                                              child: SizedBox(
                                                height: 60.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'الصور',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Icon(Icons.image),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        elevation: 0.0,
                        fillColor: Colors.grey.shade200,
                        highlightElevation: 0.0,
                        constraints: const BoxConstraints(
                          maxHeight: 50,
                          maxWidth: 50,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.attach_file,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),
                      Expanded(
                        child: AutoDirection(
                          text: _content.text,
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            textCapitalization: TextCapitalization.sentences,
                            controller: _content,
                            // cursorHeight: 22.0,
                            textDirection: isRTL(_content.text)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign: isRTL(
                                      getTranslatedData(
                                        context,
                                        "typeMessage",
                                      ),
                                    ) &&
                                    _content.text.isEmpty
                                ? (isRTL(
                                          getTranslatedData(
                                            context,
                                            "typeMessage",
                                          ),
                                        ) &&
                                        isRTL(_content.text)
                                    ? TextAlign.right
                                    : TextAlign.right)
                                : isRTL(_content.text)
                                    ? TextAlign.right
                                    : TextAlign.left,
                            onChanged: (val) {
                              setState(() {
                                isRTL(val);
                                numLines = "\n".allMatches(val).length + 1;
                                _minHeightSize = val.length > 25 || numLines > 1
                                    ? 50.0
                                    : 45.0;
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(14, 10, 14, 3),
                              // hintStyle: const TextStyle(height: 0),
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.zero,
                              ),
                              hintText:
                                  getTranslatedData(context, "typeMessage"),
                              hintMaxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          if (_content.text.trim() != '') {
                            if (listScrollController.hasClients) {
                              listScrollController.animateTo(
                                listScrollController.position.minScrollExtent,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 100),
                              );
                            }
                            // TODO: MAKE THE LAST MESSAGE IS READ NOW

                            ChatServices chatServices = ChatServices();
                            chatServices
                                .setNewMessage(
                              userId: currentUser!.uid,
                              content: _content.text.toString().trim(),
                              contentType: 0,
                              sentByUser: true,
                              isRead: false,
                              time: Timestamp.fromDate(DateTime.now()),
                            )
                                .then((value) {
                              setState(() {
                                isRTL(_content.text);
                                isRTL(
                                  getTranslatedData(context, "typeMessage"),
                                );
                              });

                              _content.clear();
                            });
                          }
                        },
                        elevation: 0.0,
                        fillColor: const Color(0xFFFE7200),
                        highlightElevation: 0.0,
                        constraints: const BoxConstraints(
                          maxHeight: 40,
                          maxWidth: 40,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
