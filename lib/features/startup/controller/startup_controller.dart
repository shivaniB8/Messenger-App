import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/providers.dart';
import 'package:chatapp_two/common/repositories/auth.dart';
import 'package:chatapp_two/common/repositories/user.dart';
import 'package:chatapp_two/common/util/constants.dart';
import 'package:chatapp_two/common/util/ext.dart';
import 'package:chatapp_two/common/util/logger.dart';

final startUpControllerProvider = Provider<StartUpController>((ref) {
  return StartUpController(
    userRepository: UserRepository(
      authRepository: ref.watch(authRepositoryProvider),
      db: ref.watch(dbProvider),
      ref: ref,
    ),
  );
});

class StartUpController {
  final UserRepository _userRepository;
  const StartUpController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  Future<void> updateOnlineState(bool isOnline) async {
    if (_userRepository.activeUser.isNone()) return;
    final user = _userRepository.activeUser.unwrap();
    try {
      await _userRepository.users.doc(user.uid).update({
        kIsOnlineField: isOnline,
      });
    } catch (e) {
      final logger = AppLogger.getLogger((StartUpController).toString());
      logger.e("Seems like the user phone is registered, but not found in the database.");
    }
  }
}
