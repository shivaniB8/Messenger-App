import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/util/constants.dart';

class UserProfileAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const UserProfileAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    double size =
        MediaQuery.of(context).size.height + MediaQuery.of(context).size.width;
    return AppBar(
      shape: Border(
          bottom: BorderSide(
              color: isDark
                  ? kLightBgColor.withOpacity(.2)
                  : kDarkBgColor.withOpacity(.2),
              width: 0.5)),
      backgroundColor: isDark ? kDarkAppBarColor : kLightBgColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back,
            color: isDark ? kLightBgColor : kDarkBgColor),
        splashRadius: kDefaultSplashRadius,
      ),
      title: Text("Profile",
          style: TextStyle(
              fontSize: size / 55,
              color: isDark ? kLightBgColor : kDarkBgColor)),

      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Column(
      //       children: [
      //         CircleAvatar(
      //           radius: size / 17,
      //           backgroundColor: Colors.grey.withOpacity(0.2),
      //           backgroundImage: NetworkImage(roomAvatar),
      //         ),
      //         const SizedBox(height: 8),
      //
      //         Text(
      //           mobileNo,
      //           style: TextStyle(fontSize: size / 80, color: Colors.white70),
      //         ),
      //         const SizedBox(height: 12),
      //         Row(
      //           children: [
      //             Container(
      //               padding:
      //                   EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(20),
      //                 border: Border.all(color: Colors.white30),
      //               ),
      //               child: Column(
      //                 children: [
      //                   Icon(
      //                     CupertinoIcons.phone,
      //                     color: kUnselectedLabelColor,
      //                     size: size / 45,
      //                   ),
      //                   Text(
      //                     "Audio",
      //                     style: TextStyle(
      //                         fontSize: size / 80, color: Colors.white70),
      //                   )
      //                 ],
      //               ),
      //             ),
      //             const SizedBox(width: 12),
      //             Container(
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 22, vertical: 10),
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(20),
      //                   border: Border.all(color: Colors.white30)),
      //               child: Column(
      //                 children: [
      //                   Icon(
      //                     CupertinoIcons.videocam,
      //                     color: kUnselectedLabelColor,
      //                     size: size / 45,
      //                   ),
      //                   Text(
      //                     "Video",
      //                     style: TextStyle(
      //                         fontSize: size / 80, color: Colors.white70),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ],
      //         )
      //       ],
      //     ),
      //   ],
      // ),
      actions: [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
