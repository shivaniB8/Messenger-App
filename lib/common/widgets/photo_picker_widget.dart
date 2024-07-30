import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoPickerWidget extends StatelessWidget {
  const PhotoPickerWidget(
      {super.key, this.onTapCamera, this.onTapGallery, required this.isDark});

  final Function()? onTapCamera;
  final Function()? onTapGallery;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    double size = appSize(context: context, unit: 10) / 10;
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 22, bottom: 12, top: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Profile photo",
                  style: AppStyles.titleTextStyle(context)
                      .copyWith(fontSize: size - 3)),
              const Spacer(),
              IconButton(
                  icon: const Icon(CupertinoIcons.delete_simple,
                      color: Colors.grey),
                  onPressed: () {},
                  iconSize: size),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _imagePickerMedium(
                  context: context,
                  size: size,
                  icon: CupertinoIcons.camera,
                  title: "Camera",
                  onTap: onTapCamera ?? () {}),
              const SizedBox(width: 30),
              _imagePickerMedium(
                  context: context,
                  size: size,
                  icon: CupertinoIcons.photo,
                  title: "Gallery",
                  onTap: onTapGallery ?? () {}),
            ],
          )
        ],
      ),
    );
  }

  _imagePickerMedium(
          {required BuildContext context,
          required double size,
          required IconData icon,
          required Function() onTap,
          required String title}) =>
      Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(55),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.grey),
              ),
              child: Icon(icon, color: kPrimaryColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(title,
              style: AppStyles.subTitleTextStyle(context)
                  .copyWith(fontSize: size - 8, color: Colors.grey))
        ],
      );
}
