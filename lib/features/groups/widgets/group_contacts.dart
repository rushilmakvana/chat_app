import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/groups/controllers/group_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class GroupContacts extends ConsumerStatefulWidget {
  const GroupContacts({super.key});

  @override
  ConsumerState<GroupContacts> createState() => _GroupContactsState();
}

class _GroupContactsState extends ConsumerState<GroupContacts> {
  List<int> contactsIndex = [];
  @override
  void initState() {
    super.initState();
  }

  void selectContact(int index, Contact contact) {
    if (contactsIndex.contains(index)) {
      contactsIndex.remove(index);
    } else {
      contactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getGroupContacts).when(data: ((contactlist) {
      return Expanded(
        child: ListView.builder(
          itemCount: contactlist.length,
          itemBuilder: (context, index) {
            final contact = contactlist[index];
            return InkWell(
              onTap: () => selectContact(index, contact),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                ),
                child: ListTile(
                  title: Text(
                    contact.displayName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  leading: contactsIndex.contains(index)
                      ? const Icon(Icons.done)
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }), error: ((error, stackTrace) {
      return ErrorScreen(errorText: error.toString());
    }), loading: () {
      return const Loader();
    });
  }
}
