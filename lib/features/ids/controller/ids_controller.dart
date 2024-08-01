// import 'dart:developer';
// import 'dart:ui';
//
// import 'package:chatapp_two/common/models/bharat_id.dart';
// import 'package:chatapp_two/common/models/user.dart';
// import 'package:chatapp_two/common/util/constants.dart';
// import 'package:chatapp_two/features/profile/controller/user_profile_controller.dart';
// import 'package:chatapp_two/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:chatapp_two/common/providers.dart';
// import 'package:chatapp_two/common/repositories/auth.dart';
// import 'package:chatapp_two/common/repositories/user.dart';
// import 'package:chatapp_two/common/util/ext.dart';
// import 'package:chatapp_two/common/util/logger.dart';
//
// final idsControllerProvider = Provider<IdsController>((ref) {
//   return IdsController(
//     userRepository: UserRepository(
//       authRepository: ref.watch(authRepositoryProvider),
//       db: ref.watch(dbProvider),
//       ref: ref,
//     ),
//   );
// });
//
// class IdsController {
//   final UserRepository _userRepository;
//
//   const IdsController({
//     required UserRepository userRepository,
//   }) : _userRepository = userRepository;
//
//   Future<UserModel?> getUserDetails() async {
//     // if (_userRepository.activeUser.isNone()) return;
//     final user = _userRepository.activeUser.unwrap();
//     try {
//       return await _userRepository.users.doc(user.uid).get().then((value) {
//         return value.data();
//       });
//     } catch (e) {
//       final logger = AppLogger.getLogger((UsrProfileController).toString());
//       logger.e(
//           "Seems like the user phone is registered, but not found in the database.");
//     }
//     return null;
//   }
//
//   CollectionReference<BharatIdModel> bharatIds() {
//     // if (_userRepository.activeUser.isNone()) return;
//     final user = _userRepository.activeUser.unwrap();
//     return _userRepository.users
//         .doc(user.uid)
//         .collection(kUsersBharatIDsCollectionId)
//         .withConverter<BharatIdModel>(
//             fromFirestore: (snapshot, _) =>
//                 BharatIdModel.fromMap(snapshot.data()!),
//             toFirestore: (ids, _) => ids.toMap());
//   }
//
//   Future<void> create({
//     required String bharatId,
//     required int type,
//     required VoidCallback onSuccess,
//   }) async {
//     try {
//       final user = _userRepository.activeUser;
//       if (user.isNone()) {
//         logger.d("Attempted to get user without being logged in");
//         return;
//       }
//       final userId = user.unwrap();
//
//       final newId = BharatIdModel(
//         bharatId: bharatId,
//         type: type,
//       );
//       _db.collection("users").doc(newUser.uid).set(newUser.toMap());
//       onSuccess();
//     } on FirebaseAuthException catch (e) {
//       onError(_mapError(e.code));
//     } catch (e) {
//       onError(_mapError(e.toString()));
//     }
//   }
// }
