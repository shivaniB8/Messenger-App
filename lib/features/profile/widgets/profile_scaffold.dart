import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/util/constants.dart';

class ProfileScaffold extends ConsumerWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  const ProfileScaffold({super.key, required this.appBar, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isDark ? kChatRoomBackgroundDarkPath : kChatRoomBackgroundLightPath,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
