import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:twitch/app/data/constants/constants.dart';
import 'package:twitch/app/modules/home/views/auth/login_screen.dart';
import 'package:twitch/app/modules/home/views/auth/signup_screen.dart';

import '../widgets/custom_button.dart';
import '../widgets/responsive.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to \nTwitch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 50.h),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: Text('Login', style: CustomTextStyle.kBold18),
                ),
              ),
              CustomButton(
                onPressed: () {
                  Get.to(() => const SignupScreen());
                },
                child: Text(
                  'Signup',
                  style: CustomTextStyle.kBold18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
