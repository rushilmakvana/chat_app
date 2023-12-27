import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/call_history/screens/call_history_screen.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/features/groups/screens/create_group_screen.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_status.dart';
import 'package:whatsapp_clone/features/status/screens/status_screen.dart';
import 'package:whatsapp_clone/features/contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_clone/models/chat_contacts.dart';
import 'package:whatsapp_clone/models/groups.dart';

class MobileLayout extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return MobileLayoutState();
  }
}

class MobileLayoutState extends ConsumerState<MobileLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // const MobileLayout({super.key});

  late TabController tabController;
  List<Group> tempgroups = [];
  List<Widget>? searchedList = [];
  List<ChatContacts> tempcontacts = [];
  bool isSearchedListEmpty = false;
  // List<Widget> contacts = [];

  void getAllChats() async {
    tempgroups = await ref.read(chatControllerProvider).getChatGroups();
    tempcontacts = await ref.read(chatControllerProvider).chatContacts();
  }

  void getsearchedList() {
    setState(() {
      isSearchedListEmpty = false;
      searchedList = [];
      for (int i = 0; i < tempgroups.length; i++) {
        if (tempgroups[i].name.contains(searchController.text) &&
            searchController.text.isNotEmpty) {
          searchedList!.add(Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(MobileChatScreen.routeName, arguments: {
                    'name': tempgroups[i].name,
                    'uid': tempgroups[i].groupId,
                    'isGroupChat': true,
                    'profilePic': tempgroups[i].groupPic,
                  });
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      tempgroups[i].groupPic.toString(),
                    ),
                  ),
                  title: Text(
                    tempgroups[i].name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Row(
                    children: [
                      tempgroups[i].senderId ==
                                  FirebaseAuth.instance.currentUser!.uid &&
                              tempgroups[i].senderName.isNotEmpty
                          ? const Text('You: ')
                          : Text(
                              '${tempgroups[i].senderName} : ',
                            ),
                      Text(
                        tempgroups[i].lastMessage,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  trailing: Text(
                    DateFormat.Hm().format(tempgroups[i].timesent),
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
          ));
        }
      }
      for (int i = 0; i < tempcontacts.length; i++) {
        // print("message = " + tempcontacts[i].messageId.toString());
        if (tempcontacts[i].name.contains(searchController.text) &&
            searchController.text.isNotEmpty) {
          searchedList!.add(Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(MobileChatScreen.routeName, arguments: {
                    'name': tempcontacts[i].name,
                    'uid': tempcontacts[i].contactId,
                    'isGroupChat': false,
                    'profilePic': tempcontacts[i].profilePic,
                  });
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      tempcontacts[i].profilePic.toString(),
                    ),
                  ),
                  title: Text(
                    tempcontacts[i].name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    tempcontacts[i].lastMessage,
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: Text(
                    DateFormat.Hm().format(tempcontacts[i].timesent),
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
          ));
        }
      }
      if (searchedList!.isEmpty && searchController.text.isNotEmpty) {
        searchedList = null;
        // isSearchedListEmpty = true;
      }
      // print("searched list = " + searchedList.length.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
    getAllChats();
  }

  final searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    focusNode.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  var isshowSearch = false;
  var isshowSearchList = false;

  // void searchList(List fixedList,List searchedList){
  // for(int i=0;)
  // }

  void showSearchList() {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          title: isshowSearch
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        isshowSearch = false;
                        searchController.text = '';
                        searchedList = [];
                      }),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: searchController,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        onChanged: ((value) {
                          getsearchedList();
                        }),
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                              width: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Text(
                  'WhatsApp',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    // fontWeight: FontWeight.w700,
                  ),
                ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isshowSearch = true;
                });
                focusNode.requestFocus();
              },
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Create group'),
                  onTap: () => Future(
                    () => Navigator.pushNamed(
                      context,
                      CreateGroupScreen.routeName,
                    ),
                  ),
                ),
              ],
            )
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 3,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            ContactList(
              searchedList: searchedList,
              isSearchedListEmpty: isSearchedListEmpty,
            ),
            // ),
            const StatusScreen(),
            const CallHistoryScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () async {
            if (tabController.index == 0)
              Navigator.pushNamed(context, SelectContactScreen.routeName);
            else if (tabController.index == 1) {
              File? file = await pickImageFromGallary(context);
              if (file != null) {
                Navigator.pushNamed(context, ConfirmStatus.routeName,
                    arguments: file);
              }
            }
          },
          child: Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
