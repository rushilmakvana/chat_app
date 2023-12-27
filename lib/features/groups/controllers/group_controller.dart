import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/groups/repositories/group_repositories.dart';
import 'package:whatsapp_clone/models/user.dart';

final getGroupContacts = FutureProvider((ref) {
  GroupRepository repository = ref.watch(groupRepoProvider);
  return repository.getContacts();
});

final GroupControllerProvider = Provider((ref) {
  final grouprepo = ref.read(groupRepoProvider);
  return GroupController(groupRepository: grouprepo, ref: ref);
});

class GroupController {
  GroupRepository groupRepository;
  final ProviderRef ref;
  GroupController({required this.groupRepository, required this.ref});

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContacts) {
    groupRepository.createGroup(context, name, profilePic, selectedContacts);
  }
}
