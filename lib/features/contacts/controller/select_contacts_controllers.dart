import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/contacts/repositories/select_contact_repository.dart';

final getContactProvider = FutureProvider((ref) {
  final selectContactRepo = ref.watch(selectContactRepositoryProvider);
  return selectContactRepo.getContacts();
});

final selectedContactController = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactController(
      ref: ref, selectContactRepository: selectContactRepository);
});

class selectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  selectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectedContact(Contact contact, BuildContext context) {
    selectContactRepository.SelectContact(contact, context);
  }
}
