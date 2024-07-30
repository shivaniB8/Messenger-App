import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/util/ext.dart';
import 'package:chatapp_two/features/auth/controllers/auth.dart';
import 'package:fpdart/src/option.dart';

import '../models/user.dart';

// Should only be used in places where we can assume
// that the user is logged in.
String getUserId(WidgetRef ref) {
  return ref.read(authControllerProvider).currentUser.unwrap().uid;
}

UserModel getUserDetails(WidgetRef ref) {
  return ref.read(authControllerProvider).currentUser.unwrap();
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      content: Text(message),
      duration: const Duration(seconds: 3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}

String removePhoneDecoration(String phone) {
  return phone
      .replaceAll(' ', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll('-', '');
}
