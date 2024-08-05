import 'dart:developer';
import 'package:chatapp_two/common/res/app_bottomsheets.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/widgets/bharat_ids_list_widget.dart';
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
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
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
                  goToContact(ref, contact, context, isDark);
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

  void goToContact(
      WidgetRef ref, Contact con, BuildContext context, bool isDark) {
    ref.read(selectContactProvider).findContact(
          selected: con,
          contactNotFound: () {
            /// contact not registered
            /// select any one of bharat ids
            /// take to the chat room to send message
            /// show alert saying : the user is not registered on Bharat Messenger, once he registers then he will see your message
            /// as sender send first message , the receiver gets regsitered in database
            ///
            // AppBottomSheet.show(
            //     context: context,
            //     child: BharatIdsListWidget(
            //       callback: (bharatId) async {
            //         /// register the user first and get the uid.
            //         await ref.read(userRepositoryProvider).create(
            //               name: con.displayName,
            //               avatar: const Option<File>.none(),
            //               onError: (error) => showSnackbar(context, error),
            //               onSuccess: () => {
            //                 Navigator.pushNamedAndRemoveUntil(
            //                     context, PageRouter.home, (route) => false),
            //               },
            //             );
            //
            //         // Navigator.pushReplacementNamed(context, PageRouter.chat,
            //         //     arguments: {
            //         //       "bharatId": bharatId,
            //         //       "phoneNumber": con.phones.first.normalizedNumber,
            //         //       'isGroup': false,
            //         //       'streamId': con.uid,
            //         //       'name': user.name,
            //         //       'avatarImage': user.profileImage,
            //         //     });
            //       },
            //     ),
            //     isDismissible: true,
            //     backgroundColor: isDark ? kDarkBgColor : kLightBgColor);
            log("contact not registered :: ${con}");
            showSnackbar(
              context,
              "This contact is not registered on $kAppName",
            );
          },
          contactFound: (user) {
            ///  contact found successfully..
            ///  show all bharat ids list to choose one or create new
            ///  start chat window
            ///  start sending messages
            ///

            AppBottomSheet.show(
                context: context,
                child: BharatIdsListWidget(
                  callback: (bharatId) {
                    Navigator.pushReplacementNamed(context, PageRouter.chat,
                        arguments: {
                          "bharatId": bharatId,
                          "phoneNumber": user.phoneNumber,
                          'isGroup': false,
                          'streamId': user.uid,
                          'name': user.name,
                          'avatarImage': user.profileImage,
                        });
                  },
                ),
                isDismissible: true,
                backgroundColor: isDark ? kDarkBgColor : kLightBgColor);

            // Navigator.pushReplacementNamed(context, PageRouter.chat,
            //     arguments: {
            //       "bharatId": "",
            //       "phoneNumber": user.phoneNumber,
            //       'isGroup': false,
            //       'streamId': user.uid,
            //       'name': user.name,
            //       'avatarImage': user.profileImage,
            //     });
          },
        );
  }
}
