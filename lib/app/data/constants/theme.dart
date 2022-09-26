import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitch/app/data/constants/constants.dart';

ThemeData mainTheme = ThemeData.dark()
    .copyWith(scaffoldBackgroundColor: CustomColors.primaryColor);

SystemUiOverlayStyle defaultOverlay = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarColor: Colors.black);
