import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/models/user.dart';
import 'package:chatapp_two/common/repositories/user.dart';
import 'package:chatapp_two/common/util/logger.dart';
import 'package:chatapp_two/features/contact/repository/contact.dart';

final readAllContactsProvider = FutureProvider((ref) {
  return ref.watch(contactRepositoryProvider).getAll();
});

final searchUserProvider = StateProvider<String>((ref) => '');

final selectContactProvider = Provider((ref) {
  var res = SelectContactController(
    userRepository: ref.read(userRepositoryProvider),
    contactRepository: ref.read(contactRepositoryProvider),
  );

  log("selectContactProvider :: $res");

  return res;
});

class SelectContactController {
  final UserRepository userRepository;
  final ContactRepository contactRepository;

  const SelectContactController({
    required this.userRepository,
    required this.contactRepository,
  });

  void findContact({
    required Contact selected,
    required VoidCallback contactNotFound,
    required Function(UserModel user) contactFound,
  }) async {
    AppLogger.getLogger('Contact')
        .i("Before replace contact with phone: ${selected.phones[0].number}");
    String phone = selected.phones[0].normalizedNumber
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '');

    // make sure the phone starts with +
    if (!phone.startsWith('+')) {
      phone = '+$phone';
    }
    AppLogger.getLogger('Contact').i("Finding contact with phone: $phone");

    final query = await userRepository.users
        .where("phoneNumber", isEqualTo: phone)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return contactNotFound();
    }
    // This should not happen anyway
    // if (query.docs[0].data().phoneNumber != phone) {
    //   log("docs[0] ? ${query.docs[0].data().phoneNumber}  $phone");
    //   return contactNotFound();
    // }
    contactFound(query.docs[0].data());
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchUserController, List>((ref) {
  return SearchUserController();
});

class SearchUserController extends StateNotifier<List> {
  SearchUserController() : super([]);

  void onSearchUser(String query, List<dynamic> data) {
    state = [];
    if (query.isNotEmpty) {
      log("list isNotEmpty :: $query");
      final result = data
          .where((element) => element.displayName
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase()))
          .toSet()
          .toList();
      state.addAll(result);
    }
  }
}
