import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/status/repositories/status_repository.dart';
import 'package:whatsapp_clone/models/status_model.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepo = ref.read(statusRepoProvider);
  return StatusController(statusRepository: statusRepo, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  void addStatus(
    File file,
    BuildContext context,
  ) {
    print('called add status');
    ref.watch(userDataAuthProvider).whenData((value) => {
          statusRepository.uploadStatus(
            username: value!.name,
            profilePic: value.profilepic,
            phoneNumber: value.phoneNumber,
            statusImage: file,
            context: context,
          )
        });
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    // print('called controller');
    final statuses = await statusRepository.getStatus(context);
    // print('statuses = ' + statuses.toString());
    return statuses;
  }
}
