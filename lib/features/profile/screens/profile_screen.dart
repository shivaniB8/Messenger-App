import 'package:chatapp_two/features/profile/widgets/profile_appbar.dart';
import 'package:chatapp_two/features/profile/widgets/profile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen(
      {required this.roomAvatar,
      required this.userName,
      required this.bharatId,
      required this.mobileNo,
      super.key});

  final String roomAvatar;
  final String userName;
  final String bharatId;
  final String mobileNo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileScaffold(
        appBar: ProfileAppBar(roomAvatar, userName, mobileNo, bharatId),
        body: Container());
  }
}
