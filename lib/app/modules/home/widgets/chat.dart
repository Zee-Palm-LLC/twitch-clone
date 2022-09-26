import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:twitch/app/data/constants/constants.dart';
import 'package:twitch/app/modules/home/controllers/livestream_controller.dart';
import 'package:twitch/app/modules/home/controllers/user_controller.dart';
import 'package:twitch/app/modules/home/models/comments.dart';
import 'package:twitch/app/modules/home/models/user_model.dart';
import 'package:twitch/app/modules/home/widgets/custom_textformfield.dart';

class Chat extends StatefulWidget {
  final String channelId;
  const Chat({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Get.find<UserController>().user;
    var lc = Get.find<LiveStreamController>();
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width > 600 ? size.width * 0.25 : double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: lc.getComment(channelId: widget.channelId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                List<CommentsModel>? commentList = snapshot.data;
                return ListView.builder(
                  itemCount: commentList?.length ?? 0,
                  itemBuilder: (context, index) => Container(
                    height: 50.h,
                    child: ListTile(
                      title: Text(
                        commentList?[index].username ?? '',
                        style: TextStyle(
                          color: commentList?[index].ownerId == user.uid
                              ? Colors.blue
                              : Colors.green,
                        ),
                      ),
                      subtitle: Text(commentList?[index].message ?? '',
                          style: CustomTextStyle.kMedium16
                              .copyWith(color: CustomColors.backgroundColor)),
                    ),
                  ),
                );
              },
            ),
          ),
          TextFieldInput(
            textEditingController: _chatController,
            onFieldSubmitted: (val) {
              lc.chat(id: widget.channelId, text: _chatController.text);
              setState(() {
                _chatController.text = "";
              });
            },
            hintText: 'Send Message',
            textInputType: TextInputType.text,
            isPass: false,
          )
        ],
      ),
    );
  }
}
