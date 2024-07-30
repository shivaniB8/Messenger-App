import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileEditTextFieldWidget extends StatelessWidget {
  const ProfileEditTextFieldWidget(
      {super.key,
      required this.title,
      required this.isDark,
      required this.controller,
      this.onSave});

  final String title;
  final bool isDark;
  final TextEditingController controller;
  final Function()? onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppStyles.titleTextStyle(context)
                  .copyWith(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: CupertinoTextField(
                controller: controller,
                style: AppStyles.titleTextStyle(context).copyWith(
                    color: isDark
                        ? kLightTextFieldBgColor
                        : kDarkTextFieldBgColor),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: kPrimaryColor))),
              )),
              const SizedBox(width: 12),
              const Icon(CupertinoIcons.smiley)
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _btn("Cancel", () => Navigator.of(context).pop()),
              _btn("Save", onSave),
            ],
          )
        ],
      ),
    );
  }

  _btn(String text, Function()? onTap) =>
      TextButton(onPressed: onTap, child: Text(text));
}
