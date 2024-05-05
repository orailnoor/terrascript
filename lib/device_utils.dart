import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 700 ? true : false;
  }

  static double screenHeight(BuildContext context, {double percentage = 100}) {
    final double screenHeight =
        MediaQuery.of(context).size.height * (percentage / 100);
    return screenHeight;
  }

  static double screenWidth(BuildContext context, {double percentage = 100}) {
    final double screenWidth =
        MediaQuery.of(context).size.width * (percentage / 100);

    return screenWidth;
  }
}
