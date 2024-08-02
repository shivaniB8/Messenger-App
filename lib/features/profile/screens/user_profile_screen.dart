import 'dart:developer';
import 'dart:io';
import 'package:chatapp_two/common/models/user.dart';
import 'package:chatapp_two/common/repositories/storage.dart';
import 'package:chatapp_two/common/res/app_bottomsheets.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/util/constants.dart';
import 'package:chatapp_two/common/util/ext.dart';
import 'package:chatapp_two/common/util/file_picker.dart';
import 'package:chatapp_two/common/util/misc.dart';
import 'package:chatapp_two/common/widgets/profile_avatar.dart';
import 'package:chatapp_two/common/widgets/profile_edit_textfield_widget.dart';
import 'package:chatapp_two/features/profile/controller/user_profile_controller.dart';
import 'package:chatapp_two/features/profile/widgets/qr_widget.dart';
import 'package:chatapp_two/features/profile/widgets/user_profile_appbar.dart';
import 'package:chatapp_two/features/profile/widgets/user_profile_scaffold.dart';
import 'package:chatapp_two/features/profile/widgets/user_profile_textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  String uid = "";
  String name = "";
  String mobile = "";
  String profileImageFromFirebase = "";
  String about = "";
  File? selectedImage;

  final _nameController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDetailsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return UserProfileScaffold(
      appBar: const UserProfileAppBar(),
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 22),
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      // String qrData =
                      //     "$uid, $name, Indian, Male, [1, 1, 1, 1, 1, 1]";
                      Map<String, dynamic> qrData = {
                        "id": uid,
                        "name": name,
                        "resident": "Indian",
                        "gender": "Male",
                        "documents": [1, 1, 1, 1, 1, 1]
                      };
                      log("length >? ${qrData.toString().length}");
                      AppBottomSheet.show(
                          backgroundColor: kLightBgColor,
                          context: context,
                          child: QrWidget(
                            qrData: qrData.toString(),
                            qrVersion: 10,
                            bharatIdLabel: "",
                          ));
                    },
                    icon: const Icon(CupertinoIcons.qrcode)),
                const SizedBox(width: 6),
                ProfileAvatar(
                  image: profileImageFromFirebase,
                  isDark: isDark,
                  onTapCamera: attachCamera,
                  onTapGallery: attachGalleryImage,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 22),
            UserProfileTextFieldWidget(
                isDark: isDark,
                title: "Name",
                value: name,
                instructions:
                    "This name will be visible to your Bharat Messenger contacts",
                leadingIcon: CupertinoIcons.person,
                isEdit: true,
                onEditTap: () {
                  AppBottomSheet.show(
                      backgroundColor: isDark ? kDarkBgColor : kLightBgColor,
                      context: context,
                      child: ProfileEditTextFieldWidget(
                          onSave: () {
                            _updateProfile(selectedImageUrl: null);
                            Navigator.of(context).pop();
                          },
                          controller: _nameController,
                          isDark: isDark,
                          title: "Enter your name"));
                }),
            UserProfileTextFieldWidget(
                isDark: isDark,
                title: "About",
                value: about,
                leadingIcon: CupertinoIcons.info,
                isEdit: true,
                onEditTap: () {
                  AppBottomSheet.show(
                      backgroundColor: isDark ? kDarkBgColor : kLightBgColor,
                      context: context,
                      child: ProfileEditTextFieldWidget(
                          onSave: () {
                            _updateProfile(
                                selectedImageUrl: null,
                                status: _statusController.text);
                            Navigator.of(context).pop();
                          },
                          controller: _statusController,
                          isDark: isDark,
                          title: "Add Status"));
                }),
            UserProfileTextFieldWidget(
                isDark: isDark,
                title: "Phone",
                value: mobile,
                leadingIcon: CupertinoIcons.phone_fill,
                isEdit: false),
          ],
        ),
      ),
    );
  }

  void getDetailsFromFirebase() async {
    UserModel? userModel =
        await ref.read(userProfileControllerProvider).getUserDetails();
    setState(() {
      uid = userModel?.uid ?? "";
      name = userModel?.name ?? "";
      mobile = userModel?.phoneNumber ?? "";
      profileImageFromFirebase = userModel?.profileImage ?? "";
      about = userModel?.about ?? "";
    });

    log("name $name");
    log("mobile $mobile");
    log("profileImage $profileImageFromFirebase");
  }

  void _updateProfile({String? selectedImageUrl, String? status}) async {
    await ref.read(userProfileControllerProvider).updateUserDetails(
        name: _nameController.text,
        profileImage: selectedImageUrl,
        status: status);
    await Future.delayed(const Duration(milliseconds: 1200));
    getDetailsFromFirebase();
  }

  void attachGalleryImage() async {
    final maybeImage = await FilePicker.pickFile(FilePickerSource.galleryImage)
        .whenComplete(() => Navigator.of(context).pop());
    if (maybeImage.isSome()) {
      log("image from gallery > $maybeImage");
      _saveFileToStorage(maybeImage.unwrap());
      // sendFile(maybeImage.unwrap(), MessageType.image);
    }
  }

  void attachCamera() async {
    final image = await FilePicker.pickFile(FilePickerSource.camera)
        .whenComplete(() => Navigator.of(context).pop());
    if (image.isSome()) {
      log("image from camera > $image");
      _saveFileToStorage(image.unwrap());
      // sendFile(image.unwrap(), MessageType.image);
    }
  }

  void _saveFileToStorage(File? img) async {
    String userId = getUserId(ref);
    log("user id current > $userId");
    if (img != null) {
      final url = await ref.read(storageRepositoryProvider).uploadFile(
            path: "$kUsersCollectionId/$userId/avatar",
            file: img,
          );
      _updateProfile(selectedImageUrl: url);
      // log("uploaded url > $url");
      // setState(() {
      //   selectedImageUrl = url;
      // });
    }
  }
}
