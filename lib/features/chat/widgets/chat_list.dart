import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/my_message.dart';
import 'package:whatsapp_clone/features/chat/widgets/sender_message.dart';
import 'package:whatsapp_clone/models/messages.dart';
import 'package:whatsapp_clone/providers/message_reply_provider.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverId;
  final bool isGroupChat;
  const ChatList({required this.recieverId, required this.isGroupChat});

  ConsumerState<ChatList> createState() {
    return ChatListState();
  }
}

class ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();

  void onMessageSwipe({
    required bool isMe,
    required String message,
    required MessageEnum messageEnum,
  }) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            isMe,
            message,
            messageEnum,
          ),
        );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .getGroupChatStream(widget.recieverId)
            : ref.read(chatControllerProvider).getChatStream(widget.recieverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];

              // print("sender  = " + messageData.senderId);
              var timesent = DateFormat.Hm().format(messageData.timesent);
              // print('timesent = ' + messageData.toString());
              if (!messageData.isseen &&
                  messageData.revieverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                    context, widget.recieverId, messageData.messageId);
              }
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessage(
                  message: messageData.text.toString(),
                  date: timesent,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  repliesMessageType: messageData.repliedTexttype,
                  username: messageData.repliedTo,
                  onswipeleft: () {
                    TempUserName.setName(messageData.senderId);
                    // print("ddkjflsdjsdlskjd = " + TempUserName.name.toString());
                    onMessageSwipe(
                      message: messageData.text,
                      isMe: true,
                      messageEnum: messageData.type,
                    );
                  },
                  isSeen: messageData.isseen,
                );
              }
              return SenderMessage(
                senderId: messageData.senderId,
                isGroupChat: widget.isGroupChat,
                message: messageData.text.toString(),
                date: timesent,
                type: messageData.type,
                onswipeleft: () {
                  TempUserName.setName(messageData.senderId);
                  ref.read(messageReplyProvider.state).update(
                        (state) => MessageReply(
                          false,
                          messageData.text,
                          messageData.type,
                          username: widget.recieverId,
                        ),
                      );
                },
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliesMessageType: messageData.repliedTexttype,
              );
            },
            itemCount: snapshot.data!.length,
          );
        });
  }
}
