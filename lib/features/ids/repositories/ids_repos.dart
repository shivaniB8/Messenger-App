// import 'dart:developer';
//
// import 'package:chatapp_two/common/models/bharat_id.dart';
// import 'package:chatapp_two/common/repositories/auth.dart';
// import 'package:chatapp_two/common/repositories/storage.dart';
// import 'package:chatapp_two/common/repositories/user.dart';
// import 'package:chatapp_two/common/util/ext.dart';
// import 'package:chatapp_two/common/util/logger.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logger/logger.dart';
//
// final bharatIdsRepositoryProvider = Provider((ref) {
//   return BharatIdsRepository(
//     user: ref.read(userRepositoryProvider),
//     auth: ref.read(authRepositoryProvider),
//     storage: ref.read(storageRepositoryProvider),
//   );
// }, name: (BharatIdsRepository).toString());
//
// class BharatIdsRepository {
//   final UserRepository _db;
//   final AuthRepository _auth;
//   final StorageRepository _storage;
//   final Logger _logger = AppLogger.getLogger((BharatIdsRepository).toString());
//
//   BharatIdsRepository({
//     required UserRepository user,
//     required AuthRepository auth,
//     required StorageRepository storage,
//   })  : _db = user,
//         _auth = auth,
//         _storage = storage;
//
//   Future<void> saveBharatId(bharatId, type) async {
//     final activeUser = _auth.currentUser;
//     final userId =
//         activeUser.unwrap().uid; // assuming that the user is logged in
//
//     final newBharatId = BharatIdModel(bharatId: bharatId, type: type);
//
//     await _db.bharatIds(userId).doc(id).set(newMsg);
//     await _db
//         .chatMessages(userId: receiverId, chatId: sender.uid)
//         .doc(id)
//         .set(newMsg);
//   }
// }
