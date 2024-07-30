import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle titleTextStyle(BuildContext context) => TextStyle(
      fontSize: appSize(context: context, unit: 10) / 15,
      fontWeight: FontWeight.w500);

  static TextStyle subTitleTextStyle(BuildContext context) =>
      TextStyle(fontSize: appSize(context: context, unit: 10) / 20);
}
