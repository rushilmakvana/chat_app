import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repositories/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_contacts.dart';
import 'package:whatsapp_clone/models/groups.dart';
import 'package:whatsapp_clone/models/messages.dart';
import 'package:whatsapp_clone/providers/message_reply_provider.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(ChatRepoProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Future<List<ChatContacts>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverId,
    required bool isGroupChat,
  }) {
    // print("called");
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) {
      // print("called = " + isGroupChat.toString());
      // print("value  = " + value.toString());
      chatRepository.sendTextMessage(
        context: context,
        text: text,
        recieverId: recieverId,
        senderUser: value!,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
    });
    ref.read(messageReplyProvider.state).update((state) => null);
    // print("called send");
  }

  Stream<List<Message>> getChatStream(String recieverId) {
    return chatRepository.getChatStream(recieverId);
  }

  Stream<List<Message>> getGroupChatStream(String recieverId) {
    return chatRepository.getGroupChatStream(recieverId);
  }

  void sendFileMessage(BuildContext context, File file, String recieverId,
      MessageEnum messageEnum, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) {
      chatRepository.sendFiles(
        context: context,
        type: messageEnum,
        recieverId: recieverId,
        userData: value!,
        file: file,
        ref: ref,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
    });
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGif(BuildContext context, String gifUrl, String recieverId,
      bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    int index = gifUrl.lastIndexOf('-') + 1;
    String urlPart = gifUrl.substring(index);
    String newUrl = 'https://i.giphy.com/media/$urlPart/200.gif';

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGifFile(
            context: context,
            gifUrl: newUrl,
            recieverId: recieverId,
            userData: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );

    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context, String recieverId, String messageId) {
    ref
        .read(ChatRepoProvider)
        .setChatMessageSeen(context, recieverId, messageId);
  }

  Future<List<Group>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Group>> groupChatStream() {
    return chatRepository.groupChatStream();
  }

  Stream<List<ChatContacts>> getChatContactsStream() {
    return chatRepository.getChatContactsStream();
  }

  Future<bool> getSeenStatus(String messageId, String recieverId) async {
    return chatRepository.getSeenStatus(messageId, recieverId);
  }

  Future<String> getGroupUserName(String id) async {
    print("id = " + id);
    return chatRepository.getGroupUserName(id);
  }
}
