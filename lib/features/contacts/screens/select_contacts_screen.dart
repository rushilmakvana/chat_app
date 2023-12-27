import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/contacts/controller/select_contacts_controllers.dart';

class SelectContactScreen extends ConsumerWidget {
  static const routeName = '/select-contacts';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Select Contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactProvider).when(data: (contacts) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListView.builder(
            itemBuilder: ((context, index) {
              return InkWell(
                onTap: () => ref
                    .read(selectedContactController)
                    .selectedContact(contacts[index], context),
                child: ListTile(
                  title: Text(
                    contacts[index].displayName,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  leading: contacts[index].photo == null
                      ? null
                      : CircleAvatar(
                          backgroundImage: MemoryImage(
                            contacts[index].photo!,
                          ),
                          radius: 30,
                        ),
                ),
              );
            }),
            itemCount: contacts.length,
          ),
        );
      }, error: (err, trace) {
        return ErrorScreen(errorText: err.toString());
      }, loading: () {
        return const Loader();
      }),
    );
  }
}
