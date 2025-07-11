import 'dart:developer';
import 'package:chatapp_two/common/repositories/user.dart';
import 'package:chatapp_two/common/res/app_bottomsheets.dart';
import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/util/misc.dart';
import 'package:chatapp_two/common/widgets/profile_edit_textfield_widget.dart';
import 'package:chatapp_two/features/ids/controller/ids_controller.dart';
import 'package:chatapp_two/features/ids/widgets/my_ids_appbar.dart';
import 'package:chatapp_two/features/profile/widgets/qr_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/models/bharat_id.dart';

class MyIdsScreen extends ConsumerStatefulWidget {
  const MyIdsScreen({super.key});

  @override
  ConsumerState<MyIdsScreen> createState() => _MyIdsScreenState();
}

class _MyIdsScreenState extends ConsumerState<MyIdsScreen> {
  bool _primaryIdValue = true;
  bool sendingNewBharatIdRequest = false;
  final _idTextController = TextEditingController();
  List<BharatIdModel> secIds = [];
  BharatIdModel? priId;

  @override
  void initState() {
    super.initState();
    _getIds();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.9),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add New ID"),
        onPressed: () async {
          // _db
          //     .collection("users")
          //     .doc(newUser.uid)
          //     .collection(kUsersBharatIDsCollectionName).get()
          // var s = await ref
          //     .read(userRepositoryProvider)
          //     .bharatIds(getUserId(ref))
          //     .get();
          // log("message :>>: ${s.docs[0]}");

          ///
          AppBottomSheet.show(
              isDismissible: true,
              backgroundColor: isDark ? kDarkBgColor : kLightBgColor,
              context: context,
              child: ProfileEditTextFieldWidget(
                  onSave: () async {
                    _createNewBharatId();
                    // _updateProfile(
                    //     selectedImageUrl: null,
                    //     status: _statusController.text);
                  },
                  controller: _idTextController,
                  isDark: isDark,
                  title: "Add New Bharat ID"));
        },
      ),
      appBar: const MyIdsAppBar(),
      body: Column(
        children: [
          Material(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Primary ID",
                      style: AppStyles.subTitleTextStyle(context)),
                  const SizedBox(height: 12),
                  _idContainer(
                      type: priId?.type ?? 1,
                      priId?.bharatId ?? "",
                      priId?.status == 0 ? false : true,
                      (v) {})
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (secIds.isNotEmpty)
            Material(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Secondary IDs",
                        style: AppStyles.subTitleTextStyle(context)),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(
                          secIds.length,
                          (index) => _idContainer(
                                type: secIds[index].type,
                                secIds[index].bharatId,
                                secIds[index].status == 0 ? false : true,
                                (v) async {
                                  _toggleBharatIdStatus(
                                      secIds[index].status == 0 ? 1 : 0,
                                      secIds[index].id);
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));
                                  _getIds();
                                  // String idOfBharatId =;
                                  //
                                  // /// update status ...
                                  // ref.read(idsControllerProvider).updateStatus(
                                  //     status: (secIds[index].status == 0
                                  //         ? 1
                                  //         : 0),
                                  //     idOfBharatId: idOfBharatId);
                                },
                              )),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  _idContainer(id, bool idValue, onChanged, {required int type}) => Row(
        children: [
          Expanded(
            child: SwitchListTile(
              // tileColor: Colors.red,
              title: Text(id),
              value: idValue,
              onChanged: onChanged,
              activeColor: (type == 1) ? Colors.white : null,
            ),
          ),
          IconButton(
              onPressed: () {
                String activeUserId = getUserId(ref);
                AppBottomSheet.show(
                    isDismissible: true,
                    backgroundColor: kLightBgColor,
                    context: context,
                    child: QrWidget(
                      qrData: "$activeUserId $id",
                      qrVersion: 5,
                      bharatIdLabel: id,
                    ));
              },
              icon: const Icon(CupertinoIcons.qrcode))
        ],
      );

  void _getIds() async {
    List<BharatIdModel> list = await ref
        .read(userRepositoryProvider)
        .bharatIds(getUserId(ref))
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    log("list >> $list");

    setState(() {
      secIds = list.where((element) => element.type == 2).toList();
      log("secIds > $secIds");
      List<BharatIdModel> primaryIdList =
          list.where((element) => element.type == 1).toList();

      // var s = ref
      //     .read(userRepositoryProvider)
      //     .bharatIds(getUserId(ref))
      //     .doc(secIds[0].toString())
      //     .path;
      // log("bharat document id >> $s");

      if (primaryIdList.length == 1) {
        priId = primaryIdList.single;
        log("primary ID > $primaryIdList");
        log("primary ID > $priId");
      } else {
        //TODO : show alert as error for showing primary id more than one...
      }
    });
  }

  void _createNewBharatId() async {
    if (_idTextController.text.isEmpty) {
      showSnackbar(context, "Please enter group name");
      return;
    }

    // make sure we don't send multiple requests
    if (!sendingNewBharatIdRequest) {
      sendingNewBharatIdRequest = true;
      ref.read(idsControllerProvider).createBharatId(
          context: context,
          bharatId: _idTextController.text.trim(),
          type: 2, // 2 = secondary id
          status: 1 // 1 = active & 0= inactive
          );
      _getIds();
      // ref.read(selectedGroupContacts.notifier).update((_) => const []);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _toggleBharatIdStatus(int status, String idOfBharatId) {
    ref
        .read(idsControllerProvider)
        .updateStatus(status: status, idOfBharatId: idOfBharatId);
  }

  ///
// void createNewId(bharatId, bharatIdType) async {
//   // Reference to the document under which the new collection will be created
//   DocumentReference docRef =
//       FirebaseFirestore.instance.collection("users").doc(getUserId(ref));
//   log("docRef : $docRef");
//
//   // Reference to the new collection under the document
//   CollectionReference newCollection = docRef.collection("bharat_ids");
//   log("newCollection : $newCollection");
//
//   // Adding a new document to the new collection
//   var ne = await newCollection.add({
//     'bharat_id': bharatId,
//     'type': bharatIdType
//     // 'timestamp': FieldValue.serverTimestamp(),
//   });
//   log("newCollection add: $ne");
//   print('New collection and document created');
// }
}
