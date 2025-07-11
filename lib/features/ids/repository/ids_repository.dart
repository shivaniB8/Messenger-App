import 'package:chatapp_two/common/models/bharat_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:chatapp_two/common/repositories/user.dart';
import 'package:chatapp_two/common/util/ext.dart';
import 'package:chatapp_two/common/util/logger.dart';

final idsRepositoryProvider = Provider<IdsRepository>((ref) {
  return IdsRepository(
    db: ref.read(userRepositoryProvider),
    ref: ref,
  );
});

class IdsRepository {
  final UserRepository _db;
  final Ref _ref;
  static final _logger = AppLogger.getLogger((IdsRepository).toString());

  const IdsRepository({
    required UserRepository db,
    required Ref ref,
  })  : _db = db,
        _ref = ref;

  Future<void> createId({
    required String bharatId,
    required int type,
    required int status,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      final String currentUserId = _db.activeUser.unwrap().uid;
      // final List<String> members = [];
      // for (Contact entry in selectedContacts) {
      //   final query = await _db.users
      //       .where(kPhoneNumberField,
      //           isEqualTo: entry.phones[0].normalizedNumber)
      //       .get();
      //   if (query.docs.isNotEmpty && query.docs[0].exists) {
      //     members.add(query.docs[0].id);
      //   }
      // }

      final bharatUuid = const Uuid().v4();

      // final profileImage = await groupImage.match(
      //       () async => kDefaultGroupAvatarUrl,
      //       (file) async {
      //     return await _ref.read(storageRepositoryProvider).uploadFile(
      //       path: 'group/$groupId',
      //       file: file,
      //     );
      //   },
      // );
      final bharatNewId = BharatIdModel(
        qr: "",
        id: bharatUuid,
        bharatId: bharatId,
        type: type,
        status: status,
      );
      await _db.bharatIds(currentUserId).doc(bharatUuid).set(bharatNewId);
      onSuccess();
    } catch (e) {
      _logger.e(e.toString());
      onError();
    }
  }

  Future<void> changesStatus({
    required int status,
    required String idOfBharatId,
  }) async {
    try {
      final String currentUserId = _db.activeUser.unwrap().uid;
      await _db
          .bharatIds(currentUserId)
          .doc(idOfBharatId)
          .update({"status": status});

      ///
    } catch (e) {
      _logger.e(e.toString());
    }
  }
}
