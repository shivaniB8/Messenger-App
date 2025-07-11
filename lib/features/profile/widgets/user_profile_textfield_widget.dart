import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileTextFieldWidget extends ConsumerWidget {
  const UserProfileTextFieldWidget(
      {super.key,
      this.onEditTap,
      required this.title,
      required this.isDark,
      required this.value,
      this.instructions,
      required this.leadingIcon,
      required this.isEdit});

  final String title;
  final String value;
  final String? instructions;
  final IconData leadingIcon;
  final bool isEdit;
  final bool isDark;
  final Function()? onEditTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(leadingIcon,
            color: isDark ? kDefaultIconLightColor : kDefaultIconDarkColor),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: AppStyles.subTitleTextStyle(context)
                        .copyWith(color: Colors.grey)),
                Row(
                  children: [
                    Expanded(
                      child: Text(value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: AppStyles.titleTextStyle(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isEdit)
            IconButton(
                icon: const Icon(Icons.mode_edit_outlined),
                onPressed: onEditTap,
                iconSize: appSize(context: context, unit: 10) / 9,
                color: isDark ? kDefaultIconLightColor : kDefaultIconDarkColor)
        ],
      ),
      subtitle: (instructions != null)
          ? Text(instructions ?? "",
              style: AppStyles.subTitleTextStyle(context)
                  .copyWith(color: Colors.grey))
          : const SizedBox.shrink(),
    );
  }
}
