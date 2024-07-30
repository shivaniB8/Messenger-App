// import 'package:chatapp_two/common/models/user.dart';
// import 'package:chatapp_two/common/repositories/auth.dart';
// import 'package:chatapp_two/common/repositories/storage.dart';
// import 'package:chatapp_two/common/repositories/user.dart';
// import 'package:chatapp_two/common/util/constants.dart';
// import 'package:chatapp_two/common/util/logger.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logger/logger.dart';
//
// final userProfileRepositoryProvider = Provider((ref) {
//   return UserProfileRepository(
//     user: ref.read(userRepositoryProvider),
//     auth: ref.read(authRepositoryProvider),
//     storage: ref.read(storageRepositoryProvider),
//   );
// }, name: (UserProfileRepository).toString());
//
// class UserProfileRepository {
//   final UserRepository _db;
//   final AuthRepository _auth;
//   final StorageRepository _storage;
//   final Logger _logger =
//       AppLogger.getLogger((UserProfileRepository).toString());
//
//   UserProfileRepository({
//     required UserRepository user,
//     required AuthRepository auth,
//     required StorageRepository storage,
//   })  : _db = user,
//         _auth = auth,
//         _storage = storage;
//
//
//   Stream<UserModel> getUsers(String userId) {
//      _db.users
//         .doc(userId).withConverter(fromFirestore: UserModel(uid: uid, name: name, profileImage: profileImage, phoneNumber: phoneNumber, isOnline: isOnline), toFirestore: toFirestore)
//         // .collection(kChatsSubCollectionId)
//         // .orderBy('timeSent')
//         // .snapshots()
//         // .map((event) {
//       // return event.docs.map((e) => MessageModel.fromMap(e.data())).toList();
//     // });
//   }
// }
