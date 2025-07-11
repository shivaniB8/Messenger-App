import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.title, this.onTap});

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: kPrimaryColor,
            child: Text(
              title,
              style: AppStyles.titleTextStyle(context),
            ),
          ),
        ),
      ],
    );
  }
}
