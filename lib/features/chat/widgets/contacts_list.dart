import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/models/chat_contacts.dart';
import 'package:whatsapp_clone/models/groups.dart';

class ContactList extends ConsumerWidget {
  List<Widget>? searchedList;
  final bool isSearchedListEmpty;

  ContactList({required this.searchedList, required this.isSearchedListEmpty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (searchedList == null) Container(),
            if (searchedList != null && searchedList!.isEmpty) ...[
              StreamBuilder<List<Group>>(
                  stream: ref.watch(chatControllerProvider).groupChatStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        print("senders = " +
                            snapshot.data![index].senderName +
                            "\n" +
                            snapshot.data![index].senderId);
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MobileChatScreen.routeName,
                                    arguments: {
                                      'name': snapshot.data![index].name,
                                      'uid': snapshot.data![index].groupId,
                                      'isGroupChat': true,
                                      'profilePic':
                                          snapshot.data![index].groupPic,
                                    });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    snapshot.data![index].groupPic.toString(),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Row(
                                  children: [
                                    snapshot.data![index].senderId ==
                                                FirebaseAuth.instance
                                                    .currentUser!.uid &&
                                            snapshot.data![index].senderName
                                                .isNotEmpty
                                        ? const Text('You: ')
                                        : Text(
                                            '${snapshot.data![index].senderName} : ',
                                          ),
                                    Text(
                                      snapshot.data![index].lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  DateFormat.Hm()
                                      .format(snapshot.data![index].timesent),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: dividerColor,
                              indent: 85,
                              // height: 1,
                            ),
                          ],
                        );
                      }),
                    );
                  }),
              StreamBuilder<List<ChatContacts>>(
                  stream:
                      ref.watch(chatControllerProvider).getChatContactsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MobileChatScreen.routeName,
                                    arguments: {
                                      'name': snapshot.data![index].name,
                                      'uid': snapshot.data![index].contactId,
                                      'isGroupChat': false,
                                      'profilePic':
                                          snapshot.data![index].profilePic,
                                    });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    snapshot.data![index].profilePic.toString(),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Row(
                                  children: [
                                    if (snapshot.data![index].senderId ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                      FutureBuilder<bool>(
                                        future: ref
                                            .read(chatControllerProvider)
                                            .getSeenStatus(
                                                snapshot
                                                    .data![index].messageId!,
                                                snapshot
                                                    .data![index].contactId),
                                        builder: ((context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          }
                                          if (snapshot.data == true) {
                                            return Row(
                                              children: const [
                                                Icon(
                                                  Icons.done_all,
                                                  size: 16,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            );
                                          }
                                          return Row(
                                            children: const [
                                              Icon(
                                                Icons.done,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    Text(
                                      snapshot.data![index].lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  DateFormat.Hm()
                                      .format(snapshot.data![index].timesent),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: dividerColor,
                              indent: 85,
                              // height: 1,
                            ),
                          ],
                        );
                      }),
                    );
                  }),
            ],
            if (searchedList != null && searchedList!.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return searchedList![index];
                },
                itemCount: searchedList!.length,
              )
          ],
        ),
      ),
    );
  }
}
