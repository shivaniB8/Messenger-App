import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/util/constants.dart';

class MyIdsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyIdsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double size = appSize(context: context, unit: 10) / 10;
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
        splashRadius: kDefaultSplashRadius,
      ),
      toolbarHeight: kToolbarHeight,
      title: Text("My Bharat IDs",
          style: TextStyle(fontSize: size - 4)),
      actions: [
        // Align(
        //   alignment: Alignment.topRight,
        //   child: IconButton(
        //     splashRadius: kDefaultSplashRadius,
        //     onPressed: () {},
        //     icon: const Icon(Icons.more_vert),
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
