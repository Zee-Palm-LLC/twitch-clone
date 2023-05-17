import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:twitch/app/modules/home/controllers/livestream_controller.dart';
import 'package:twitch/app/modules/home/controllers/user_controller.dart';
import 'package:twitch/app/modules/home/models/user_model.dart';
import 'package:twitch/app/modules/home/views/broad_cast_screen.dart';
import 'package:twitch/app/modules/home/widgets/custom_textformfield.dart';
import 'package:twitch/app/modules/home/widgets/image_pick_functionality.dart';

import '../../../data/constants/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({Key? key}) : super(key: key);

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? image;
  // final _formKey = GlobalKey<FormState>();
  LiveStreamController lc = Get.find<LiveStreamController>();
  String channelId = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Get.find<UserController>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username??''),
      ),
      body: SafeArea(
        child: Responsive(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await ImagePickerDialogBox.pickSingleImage((file) {
                            setState(() {
                              image = file;
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22.0,
                            vertical: 20.0,
                          ),
                          child: image != null
                              ? SizedBox(
                                  height: 300,
                                  width: Get.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: CustomColors.buttonColor,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: CustomColors.buttonColor
                                          .withOpacity(.05),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.folder_open,
                                          color: CustomColors.buttonColor,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          'Select your thumbnail',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Title',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: TextFieldInput(
                                textEditingController: _titleController,
                                hintText: 'Title',
                                textInputType: TextInputType.name,
                                isPass: false,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Enter a title';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.h),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: CustomButton(
                      child: Text('Go Live!', style: CustomTextStyle.kBold18),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            image != null) {
                          await goLiveStream();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  goLiveStream() async {
    String channelId =
        await lc.startLiveStream(title: _titleController.text, image: image!);
    if (channelId.isNotEmpty) {
      Get.snackbar('LiveStream', 'Livestream has started successfully!');
      Get.to(() => BroadCastScreen(isBroadCaster: true, channelId: channelId));
      //Get.to(() => BroadCastScreen());
    }
  }
}
