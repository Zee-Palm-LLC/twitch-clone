import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitch/app/modules/home/views/auth/login_screen.dart';
import 'package:twitch/app/modules/home/views/home_screen.dart';
import 'package:twitch/app/modules/home/views/onboarding.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
        init: AuthController(),
        builder: (ac) {
          if (ac.user == null) {
            return const OnboardingScreen();
          } else {
            return GetBuilder<UserController>(
                init: UserController(),
                builder: (uc) {
                  return const HomeScreen();
                });
          }
        });
  }
}
