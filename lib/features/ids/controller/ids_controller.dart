import 'package:chatapp_two/features/ids/repository/ids_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/util/misc.dart';

final idsControllerProvider = Provider<IdsController>(
  (ref) => IdsController(
    repository: ref.watch(idsRepositoryProvider),
    ref: ref,
  ),
);

class IdsController {
  final IdsRepository _idsRepository;
  final Ref _ref;

  const IdsController({
    required IdsRepository repository,
    required Ref ref,
  })  : _idsRepository = repository,
        _ref = ref;

  void createBharatId({
    required BuildContext context,
    required String bharatId,
    required int type,
    required int status,
  }) async {
    _idsRepository.createId(
      bharatId: bharatId,
      type: type,
      status: status,
      onError: () => showSnackbar(context, "Failed to create bharat id"),
      onSuccess: () {},
    );
  }

  void updateStatus({
    required int status,
    required String idOfBharatId,
  }) async {
    _idsRepository.changesStatus(status: status, idOfBharatId: idOfBharatId);
  }
}
