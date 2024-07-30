import 'package:chatapp_two/common/enum/message.dart';
import 'package:chatapp_two/common/res/app_bottomsheets.dart';
import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/util/ext.dart';
import 'package:chatapp_two/common/util/file_picker.dart';
import 'package:chatapp_two/common/widgets/photo_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(
      {super.key,
      required this.image,
      required this.isDark,
      this.onTapCamera,
      this.onTapGallery});

  final String image;
  final bool isDark;
  final Function()? onTapCamera;
  final Function()? onTapGallery;

  @override
  Widget build(BuildContext context) {
    double size = appSize(context: context, unit: 10) / 10;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: size + 50,
          backgroundColor: Colors.grey.withOpacity(0.2),
          backgroundImage: NetworkImage(image),
        ),
        FloatingActionButton.small(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(55)),
            onPressed: () {
              AppBottomSheet.show(
                  backgroundColor: Colors.transparent,
                  context: context,
                  child: PhotoPickerWidget(
                    isDark: isDark,
                    onTapCamera: onTapCamera,
                    onTapGallery: onTapGallery,
                  ));
            },
            child: Icon(CupertinoIcons.camera,
                size: size - 3, color: kDarkBgColor))
      ],
    );
  }
}
