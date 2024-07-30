import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:chatapp_two/common/util/constants.dart';
import 'package:chatapp_two/common/util/misc.dart';
import 'package:chatapp_two/common/widgets/avatar.dart';
import 'package:chatapp_two/common/widgets/error.dart';
import 'package:chatapp_two/common/widgets/progress.dart';
import 'package:chatapp_two/features/contact/controllers/contact.dart';
import 'package:chatapp_two/router.dart';

class SelectContactPage extends ConsumerStatefulWidget {
  const SelectContactPage({super.key});

  @override
  ConsumerState<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends ConsumerState<SelectContactPage> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(readAllContactsProvider);
    final searchText = ref.watch(searchUserProvider);
    final searchController = ref.watch(searchControllerProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              isSearch = !isSearch;
              setState(() {});
            },
            icon: isSearch
                ? const Icon(Icons.close_rounded)
                : const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        title: isSearch
            ? CupertinoTextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white30),
                onChanged: (v) async {
                  log("onChanged");
                  ref
                      .read(searchUserProvider.notifier)
                      .update((state) => state = v);
                  await Future.delayed(const Duration(milliseconds: 1000));
                  ref
                      .read(searchControllerProvider.notifier)
                      .onSearchUser(searchText, contacts.value ?? []);
                },
                onEditingComplete: () {
                  ref
                      .read(searchControllerProvider.notifier)
                      .onSearchUser(searchText, contacts.value ?? []);
                  FocusScope.of(context).requestFocus();
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (contacts.hasValue && contacts.value != null) ...{
                    const SizedBox(height: 4),
                    Text(
                      '${contacts.value!.length} contacts',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  }
                ],
              ),
      ),
      body: contacts.when(
        data: (contacts) {
          return ListView.builder(
            itemCount: searchController.isNotEmpty
                ? searchController.length
                : contacts.length,
            itemBuilder: (context, index) {
              final contact = searchController.isNotEmpty
                  ? searchController[index]
                  : contacts[index];
              return InkWell(
                onTap: () {
                  log("selected contact : $contact");
                  goToContact(ref, contact, context);
                },
                child: ListTile(
                  title: Text(
                    contact.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  leading: Avatar(
                    image: Option.fromNullable(contact.photo),
                  ),
                ),
              );
            },
          );
        },
        error: (err, trace) => UnhandledError(error: err.toString()),
        loading: () => const WorkProgressIndicator(),
      ),
    );
  }

  void goToContact(WidgetRef ref, Contact con, BuildContext context) {
    ref.read(selectContactProvider).findContact(
          selected: con,
          contactNotFound: () => showSnackbar(
            context,
            "This contact is not registered on $kAppName",
          ),
          contactFound: (user) {
            Navigator.pushReplacementNamed(context, PageRouter.chat,
                arguments: {
                  "phoneNumber": user.phoneNumber,
                  'isGroup': false,
                  'streamId': user.uid,
                  'name': user.name,
                  'avatarImage': user.profileImage,
                });
          },
        );
  }
}
