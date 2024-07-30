import 'package:flutter/material.dart';

class AppFunctions {

}

double appSize({required BuildContext context, required double unit}) {
  double baseUnit = 100;
  double s =
      MediaQuery.of(context).size.height + MediaQuery.of(context).size.width;
  double value = s / 100 * unit + baseUnit;
  return value;
}
