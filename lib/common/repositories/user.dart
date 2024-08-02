import 'dart:developer';
import 'dart:io';

import 'package:chatapp_two/common/models/bharat_id.dart';
import 'package:chatapp_two/features/ids/controller/ids_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:chatapp_two/common/models/call.dart';
import 'package:chatapp_two/common/models/chat.dart';
import 'package:chatapp_two/common/models/group.dart';
import 'package:chatapp_two/common/models/message.dart';
import 'package:chatapp_two/common/models/status.dart';
import 'package:chatapp_two/common/models/user.dart';
import 'package:chatapp_two/common/providers.dart';
import 'package:chatapp_two/common/repositories/auth.dart';
import 'package:chatapp_two/common/repositories/storage.dart';
import 'package:chatapp_two/common/util/constants.dart';
import 'package:chatapp_two/common/util/ext.dart';
import 'package:chatapp_two/common/util/logger.dart';
import 'package:uuid/uuid.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(
    db: ref.read(dbProvider),
    ref: ref,
    authRepository: ref.read(authRepositoryProvider),
  );
});

final userFetchProvider = FutureProvider((ref) {
  log("userFetchProvider :>>: ${ref}");
  return ref.watch(userRepositoryProvider).getUser();
});

final userFetchByIdProvider =
    FutureProvider.family<Option<UserModel>, String>((ref, id) {
  return ref.watch(userRepositoryProvider).getUserById(id);
});

final userFetchByPhoneNumberProvider =
    FutureProvider.family<Option<UserModel>, String>((ref, phoneNumber) {
  return ref.watch(userRepositoryProvider).getUserByPhoneNumber(phoneNumber);
});

final userStream = StreamProvider.family<UserModel, String>((ref, id) {
  log("StreamProvider id > $id");
  return ref.watch(userRepositoryProvider).userStream(id);
});

class UserRepository {
  final FirebaseFirestore _db;
  final AuthRepository _authRepository;
  final Ref _ref;
  static final logger = AppLogger.getLogger((UserRepository).toString());

  const UserRepository({
    required FirebaseFirestore db,
    required AuthRepository authRepository,
    required Ref ref,
  })  : _db = db,
        _authRepository = authRepository,
        _ref = ref;

  /// Get a snapshot of the current user. It will return `None` if the user is not logged in
  /// or the user does not exists in the database.
  Future<Option<UserModel>> getUser() async {
    final maybeUser = _authRepository.currentUser;
    if (maybeUser.isNone()) {
      logger.d("Attempted to get user without being logged in");
      return const Option.none();
    }
    final user = maybeUser.unwrap();
    final json = await users.doc(user.uid).get();
    if (json.data() == null) {
      logger.d("The current logged in user does not exists in the database");
      return const Option.none();
    }
    return Option.of(json.data()!);
  }

  Future<Option<UserModel>> getUserById(String uid) async {
    final json = await users.doc(uid).get();
    if (json.data() == null) {
      logger.d("The user with id $uid does not exists in the database");
      return const Option.none();
    }
    return Option.of(json.data()!);
  }

  /// Fetches a user by their phone number. It will return `None` if the user does not exists
  Future<Option<UserModel>> getUserByPhoneNumber(
      String normalizedPhoneNumber) async {
    final json = await users
        .where(kPhoneNumberField, isEqualTo: normalizedPhoneNumber)
        .get();
    if (json.docs.isEmpty) {
      logger.d(
          "The user with phone number $normalizedPhoneNumber does not exists in the database");
      return const Option.none();
    }
    return Option.of(json.docs[0].data());
  }

  Future<void> create({
    required String name,
    required Option<File> avatar,
    required Function(String err) onError,
    required VoidCallback onSuccess,
  }) async {
    try {
      final user = _authRepository.currentUser;
      if (user.isNone()) {
        logger.d("Attempted to get user without being logged in");
        return;
      }
      final userId = user.unwrap();
      String profileImage = await avatar.match(
        () async => kDefaultAvatarUrl,
        (file) async {
          final url = await _ref.read(storageRepositoryProvider).uploadFile(
                path: "$kUsersCollectionId/${userId.uid}/avatar",
                file: avatar.unwrap(),
              );
          return url;
        },
      );
      final newUser = UserModel(
        about: "",
        uid: userId.uid,
        name: name,
        profileImage: profileImage,
        phoneNumber: userId.phoneNumber,
        isOnline: true,
      );
      _db.collection("users").doc(newUser.uid).set(newUser.toMap());
      final bharatUuid = const Uuid().v4();
      _db
          .collection("users")
          .doc(newUser.uid)
          .collection(kUsersBharatIDsCollectionName)
          .doc(bharatUuid)
          .set(BharatIdModel(
                  id: bharatUuid,
                  bharatId: "${name.trim()}@bharatmessenger".toLowerCase(),
                  qr: "",
                  type: 1,
                  status: 1)
              .toMap());
      // _ref.read(idsControllerProvider).createBharatId(
      //     context: context,
      //     bharatId: _idTextController.text.trim(),
      //     type: 2, // 2 = secondary id
      //     status: 1 // 1 = active & 0= inactive
      // );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(_mapError(e.code));
    } catch (e) {
      onError(_mapError(e.toString()));
    }
  }

  String _mapError(String code) {
    logger.e("Error code: $code");
    switch (code) {
      default:
        return "Something went wrong";
    }
  }

  CollectionReference<UserModel> get users {
    return _db.collection(kUsersCollectionId).withConverter<UserModel>(
          fromFirestore: (snapshot, _) {
            var users = UserModel.fromMap(snapshot.data()!);
            log("USER if present :> $users");
            return users;
          },
          toFirestore: (user, _) => user.toMap(),
        );
  }

  CollectionReference<ChatModel> userChats(String userId) {
    return users
        .doc(userId)
        .collection(kChatsSubCollectionId)
        .withConverter<ChatModel>(
          fromFirestore: (snapshot, _) => ChatModel.fromMap(snapshot.data()!),
          toFirestore: (chat, _) => chat.toMap(),
        );
  }

  CollectionReference<BharatIdModel> bharatIds(String userId) {
    // log("bharatIds list   :::  ${users.doc(userId).collection(kUsersBharatIDsCollectionId).withConverter<BharatIdModel>(
    //       fromFirestore: (snapshot, _) =>
    //           BharatIdModel.fromMap(snapshot.data()!),
    //       toFirestore: (ids, _) => ids.toMap(),
    //     ).get().then((value) {
    //   print("list value >>> ${value.docs.first.data()}");
    // })}");
    return users
        .doc(userId)
        .collection(kUsersBharatIDsCollectionName)
        .withConverter<BharatIdModel>(
          fromFirestore: (snapshot, _) =>
              BharatIdModel.fromMap(snapshot.data()!),
          toFirestore: (ids, _) => ids.toMap(),
        );
  }

  CollectionReference<MessageModel> chatMessages({
    required String userId,
    required String chatId,
  }) {
    return userChats(userId)
        .doc(chatId)
        .collection(kMessagesSubCollectionId)
        .withConverter<MessageModel>(
          fromFirestore: (snapshot, _) =>
              MessageModel.fromMap(snapshot.data()!),
          toFirestore: (message, _) => message.toMap(),
        );
  }

  CollectionReference<StatusModel> get statuses {
    return _db.collection(kStatusCollectionId).withConverter<StatusModel>(
          fromFirestore: (snapshot, _) => StatusModel.fromMap(snapshot.data()!),
          toFirestore: (status, _) => status.toMap(),
        );
  }

  CollectionReference<GroupModel> get groups {
    return _db.collection(kGroupsCollectionId).withConverter<GroupModel>(
          fromFirestore: (snapshot, _) => GroupModel.fromMap(snapshot.data()!),
          toFirestore: (group, _) => group.toMap(),
        );
  }

  CollectionReference<CallModel> get calls {
    return _db.collection(kCallsCollection).withConverter<CallModel>(
          fromFirestore: (snapshot, _) => CallModel.fromMap(snapshot.data()!),
          toFirestore: (group, _) => group.toMap(),
        );
  }

  Query<StatusModel> userStatuses(String userId) =>
      statuses.where('uid', isEqualTo: userId);

  Stream<UserModel> userStream(String uid) {
    log("userStream > ${users.doc(uid).snapshots().map((event) => event.data()!)}");
    return users.doc(uid).snapshots().map((event) => event.data()!);
  }

  Option<UserModel> get activeUser => _authRepository.currentUser;
}
