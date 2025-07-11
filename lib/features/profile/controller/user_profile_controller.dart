import 'dart:developer';

import 'package:chatapp_two/common/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/providers.dart';
import 'package:chatapp_two/common/repositories/auth.dart';
import 'package:chatapp_two/common/repositories/user.dart';
import 'package:chatapp_two/common/util/ext.dart';
import 'package:chatapp_two/common/util/logger.dart';

final userProfileControllerProvider = Provider<UsrProfileController>((ref) {
  return UsrProfileController(
    userRepository: UserRepository(
      authRepository: ref.watch(authRepositoryProvider),
      db: ref.watch(dbProvider),
      ref: ref,
    ),
  );
});

class UsrProfileController {
  final UserRepository _userRepository;

  const UsrProfileController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  Future<UserModel?> getUserDetails() async {
    // if (_userRepository.activeUser.isNone()) return;
    final user = _userRepository.activeUser.unwrap();
    try {
      return await _userRepository.users.doc(user.uid).get().then((value) {
        return value.data();
      });
    } catch (e) {
      final logger = AppLogger.getLogger((UsrProfileController).toString());
      logger.e(
          "Seems like the user phone is registered, but not found in the database.");
    }
    return null;
  }

  Future<void> updateUserDetails(
      {String? name, String? profileImage, String? status}) async {
    if (_userRepository.activeUser.isNone()) return;
    final user = _userRepository.activeUser.unwrap();
    log("profile details :: name - image - status >>? $name - $profileImage - $status");

    // try {
    await _userRepository.users
        .doc(user.uid)
        .update({
          // "isOnline": isOnline,
          if (name != null && name.isNotEmpty) "name": name,
          if (profileImage != null && profileImage.isNotEmpty)
            "profileImage": profileImage,
          if (status != null && status.isNotEmpty) "about": status,
        })
        .then((_) => log('Profile Update Success'))
        .catchError((error) => log('Profile Update Failed: $error'));
    //     .then((value) {
    //   log("updateUserDetails > > > > :: ");
    // });
    // } catch (e) {
    //   final logger = AppLogger.getLogger((UsrProfileController).toString());
    //   logger.e(
    //       "Seems like the user phone is registered, but not found in the database.");
    // }
  }
}
