import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const CustomButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: CustomColors.buttonColor,
            fixedSize: Size(Get.width, 55.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r))),
        child: child);
  }
}
