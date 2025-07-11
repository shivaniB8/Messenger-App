import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    double size = appSize(context: context, unit: 10) / 10;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size + 10,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/img/bmlogo.png"),
                    const CupertinoActivityIndicator(radius: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text("Processing..."),
        SizedBox(height: size + 20),
      ],
    );
  }
}
