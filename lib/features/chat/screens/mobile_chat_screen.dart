import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/features/call/screens/call_pickup_screen.dart';
import 'package:whatsapp_clone/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  static const routeName = '/chat-screen';

  const MobileChatScreen({
    required this.profilePic,
    required this.isGroupChat,
    required this.name,
    required this.uid,
  });

  void makeCall(WidgetRef ref, BuildContext context) {
    ref
        .read(callControllerProvider)
        .makeCall(context, name, uid, profilePic, isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('uid = ' + isGroupChat.toString());
    return CallPickUpScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    // print('snapshot = ' + snapshot.data!.name.toString());
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        if (snapshot.data!.isOnline)
                          const Text(
                            'online',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    );
                  },
                ),
          actions: [
            IconButton(
              onPressed: () => makeCall(ref, context),
              icon: const Icon(
                Icons.video_call,
              ),
            ),
            IconButton(
              onPressed: () {
                // denyCall(context, ref);
                // ref.read(callControllerProvider).denyCall(
                //       FirebaseAuth.instance.currentUser!.uid,
                //       uid,
                //       context,
                //     );
              },
              icon: const Icon(
                Icons.call,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                recieverId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            Container(
              // height: 50,
              // color: appBarColor,
              child: BottomChatField(
                recieverId: uid,
                isGroupChat: isGroupChat,
              ),
            )
          ],
        ),
      ),
    );
  }
}
