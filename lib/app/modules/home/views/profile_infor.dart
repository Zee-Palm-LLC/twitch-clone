import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitch/app/data/constants/typography.dart';
import 'package:twitch/app/modules/home/controllers/user_controller.dart';
import 'package:twitch/app/modules/home/models/user_model.dart';

import '../controllers/auth_controller.dart';

class ProfileInfo extends StatelessWidget {
  AuthController ac = Get.find<AuthController>();
  ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = Get.find<UserController>().user;
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(user.username!, style: CustomTextStyle.kMedium20),
              Text(
                user.email!,
                style: CustomTextStyle.kMedium16,
              ),
              ElevatedButton(
                  onPressed: () {
                    ac.signOut();
                  },
                  child: Text("Sign out"))
            ]),
      ),
    );
  }
}
