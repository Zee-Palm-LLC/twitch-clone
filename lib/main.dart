import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:twitch/app/data/constants/constants.dart';
import 'package:twitch/app/modules/home/bindings/home_binding.dart';
import 'package:twitch/app/modules/home/controllers/auth_controller.dart';
import 'package:twitch/app/modules/home/views/auth/auth_wrapper.dart';
import 'package:twitch/app/modules/home/views/home_screen.dart';
import 'package:twitch/app/modules/home/views/onboarding.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (context, widget) {
        return GetMaterialApp(
          title: "Twitch",
          debugShowCheckedModeBanner: false,
          home: const AuthWrapper(),
          initialBinding: HomeBinding(),
          themeMode: ThemeMode.light,
          theme: mainTheme,
        );
      },
    );
  }
}
