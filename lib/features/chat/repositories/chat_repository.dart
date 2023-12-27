import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/repositories/storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/models/chat_contacts.dart';
import 'package:whatsapp_clone/models/groups.dart';
import 'package:whatsapp_clone/models/messages.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/providers/message_reply_provider.dart';

final ChatRepoProvider = Provider((ref) {
  return ChatRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firebaseFirestore, required this.auth});

  Stream<List<ChatContacts>> getChatContactsStream() {
    return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContacts> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContacts.fromMap(document.data());
        var userData = await firebaseFirestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContacts(
            name: user.name,
            lastMessage: chatContact.lastMessage,
            profilePic: user.profilepic,
            contactId: chatContact.contactId,
            timesent: chatContact.timesent,
            senderId: chatContact.senderId,
            messageId: chatContact.messageId,
          ),
        );
      }

      return contacts;
      // print('data = ' + contacts.toString());
    });
  }

  Future<List<ChatContacts>> getChatContacts() async {
    // return firebaseFirestore
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .collection('chats')
    //     .snapshots()
    //     .asyncMap((event) async {
    //   List<ChatContacts> contacts = [];
    //   for (var document in event.docs) {
    //     var chatContact = ChatContacts.fromMap(document.data());
    //     var userData = await firebaseFirestore
    //         .collection('users')
    //         .doc(chatContact.contactId)
    //         .get();
    //     var user = UserModel.fromMap(userData.data()!);

    //     contacts.add(
    //       ChatContacts(
    //           name: user.name,
    //           lastMessage: chatContact.lastMessage,
    //           profilePic: user.profilepic,
    //           contactId: chatContact.contactId,
    //           timesent: chatContact.timesent),
    //     );
    //   }
    //   return contacts;

    //   // print('data = ' + contacts.toString());
    // });
    final data = await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .get();
    List<ChatContacts> contacts = [];
    for (var document in data.docs) {
      var chatContact = ChatContacts.fromMap(document.data());
      var userData = await firebaseFirestore
          .collection('users')
          .doc(chatContact.contactId)
          .get();
      var user = UserModel.fromMap(userData.data()!);

      contacts.add(
        ChatContacts(
          name: user.name,
          lastMessage: chatContact.lastMessage,
          profilePic: user.profilepic,
          contactId: chatContact.contactId,
          timesent: chatContact.timesent,
          senderId: auth.currentUser!.uid,
        ),
      );
    }
    return contacts;
  }

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    String text,
    DateTime timesent,
    String recieverId,
    bool isGroupChat,
    String messageId,
  ) async {
    // print("reciever id = " + recieverId);
    if (isGroupChat) {
      await firebaseFirestore.collection('groups').doc(recieverId).update({
        'lastMessage': text,
        'timesent': DateTime.now().millisecondsSinceEpoch,
        'senderName': senderUserData.name,
        'senderId': auth.currentUser!.uid,
      });
    } else {
      var recieverChatContact = ChatContacts(
        name: senderUserData.name,
        lastMessage: text,
        profilePic: senderUserData.profilepic,
        contactId: senderUserData.uid,
        timesent: timesent,
        senderId: auth.currentUser!.uid,
        messageId: messageId,
      );
      await firebaseFirestore
          .collection('users')
          .doc(recieverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(
            recieverChatContact.toMap(),
          );
      var senderChatContact = ChatContacts(
        name: recieverUserData!.name,
        lastMessage: text,
        profilePic: recieverUserData.profilepic,
        contactId: recieverUserData.uid,
        timesent: timesent,
        senderId: auth.currentUser!.uid,
        messageId: messageId,
      );
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverId)
          .set(
            senderChatContact.toMap(),
          );
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    // print("hello");
    try {
      var timesent = DateTime.now();
      UserModel? recieverData;

      if (!isGroupChat) {
        final userDataMap =
            await firebaseFirestore.collection('users').doc(recieverId).get();
        recieverData = UserModel.fromMap(userDataMap.data()!);
      }
      // print("reciever data  = " + recieverData.toString());
      final messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(senderUser, recieverData, text, timesent,
          recieverId, isGroupChat, messageId);

      _saveMessageToMessageSubCollection(
        messageId: messageId,
        messageType: MessageEnum.text,
        recieverUserId: recieverId,
        text: text,
        timesent: timesent,
        username: senderUser.name,
        recieverUsername: recieverData?.name,
        isGroupChat: isGroupChat,
        messageReply: messageReply,
        senderUsername: senderUser.name,
        repliedMEssageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    // print("hello");
  }

  _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timesent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required String? recieverUsername,
    required MessageReply? messageReply,
    required String senderUsername,
    required MessageEnum repliedMEssageType,
    required bool isGroupChat,
  }) async {
    String? tempusername;
    if (TempUserName.name != null) {
      tempusername = await getGroupUserName(TempUserName.name!);
      TempUserName.setName(null);
      // print("temp username = " + tempusername);
    }
    final message = Message(
      senderId: auth.currentUser!.uid,
      revieverId: recieverUserId,
      text: text,
      type: messageType,
      timesent: timesent,
      messageId: messageId,
      isseen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : tempusername != null
                  ? tempusername
                  : '',
      repliedTexttype: repliedMEssageType,
    );

    if (isGroupChat) {
      await firebaseFirestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      await firebaseFirestore
          .collection(
            'users',
          )
          .doc(
            auth.currentUser!.uid,
          )
          .collection(
            'chats',
          )
          .doc(
            recieverUserId,
          )
          .collection(
            'messages',
          )
          .doc(
            messageId,
          )
          .set(
            message.toMap(),
          );
      await firebaseFirestore
          .collection(
            'users',
          )
          .doc(
            recieverUserId,
          )
          .collection(
            'chats',
          )
          .doc(
            auth.currentUser!.uid,
          )
          .collection(
            'messages',
          )
          .doc(
            messageId,
          )
          .set(
            message.toMap(),
          );
    }
  }

  Stream<List<Message>> getChatStream(String recieverId) {
    return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('timesent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];

      for (var document in event.docs) {
        messages.add(
          Message.fromMap(
            document.data(),
          ),
        );
      }
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timesent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];

      for (var document in event.docs) {
        messages.add(
          Message.fromMap(
            document.data(),
          ),
        );
      }
      return messages;
    });
  }

  void sendFiles(
      {required BuildContext context,
      required MessageEnum type,
      required String recieverId,
      required UserModel userData,
      required File file,
      required ProviderRef ref,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      var timesent = DateTime.now();
      var messageId = const Uuid().v1();
      final imageUrl = await ref
          .read(firebaseStorageProvider)
          .storeFileToForebase(
              'chat/${type.type}/${userData.uid}/$recieverId/$messageId', file);

      UserModel? recieverData;
      if (!isGroupChat) {
        final userDataMap =
            await firebaseFirestore.collection('users').doc(recieverId).get();
        recieverData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg;

      switch (type) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDataToContactsSubCollection(userData, recieverData, contactMsg,
          timesent, recieverId, isGroupChat, messageId);
      _saveMessageToMessageSubCollection(
        recieverUserId: recieverId,
        text: imageUrl,
        timesent: timesent,
        messageId: messageId,
        username: userData.name,
        messageType: type,
        recieverUsername: recieverData?.name,
        messageReply: messageReply,
        senderUsername: userData.name,
        isGroupChat: isGroupChat,
        repliedMEssageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGifFile(
      {required BuildContext context,
      required String gifUrl,
      required String recieverId,
      required UserModel userData,
      required MessageReply? messageReply,
      required bool isGroupChat,
      required}) async {
    try {
      final timesent = DateTime.now();
      final messageId = const Uuid().v1();

      UserModel? recieverData;
      if (!isGroupChat) {
        final userDataMap =
            await firebaseFirestore.collection('users').doc(recieverId).get();
        recieverData = UserModel.fromMap(userDataMap.data()!);
      }

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverId,
        text: gifUrl,
        timesent: timesent,
        messageId: messageId,
        username: userData.name,
        messageType: MessageEnum.gif,
        recieverUsername: recieverData?.name,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
        repliedMEssageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        senderUsername: userData.name,
      );

      _saveDataToContactsSubCollection(userData, recieverData, 'GIF', timesent,
          recieverId, isGroupChat, messageId);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
      BuildContext context, String recieverId, String messageId) async {
    try {
      await firebaseFirestore
          .collection(
            'users',
          )
          .doc(
            auth.currentUser!.uid,
          )
          .collection(
            'chats',
          )
          .doc(
            recieverId,
          )
          .collection(
            'messages',
          )
          .doc(
            messageId,
          )
          .update(
        {
          'isseen': true,
        },
      );
      await firebaseFirestore
          .collection(
            'users',
          )
          .doc(
            recieverId,
          )
          .collection(
            'chats',
          )
          .doc(
            auth.currentUser!.uid,
          )
          .collection(
            'messages',
          )
          .doc(
            messageId,
          )
          .update(
        {
          'isseen': true,
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<Group>> groupChatStream() {
    return firebaseFirestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];

      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      // print('groups = ' + groups.toString());
      return groups;
    });
  }

  Future<List<Group>> getChatGroups() async {
    // return firebaseFirestore.collection('groups').snapshots().map((event) {
    //   List<Group> groups = [];

    //   for (var document in event.docs) {
    //     var group = Group.fromMap(document.data());
    //     if (group.membersUid.contains(auth.currentUser!.uid)) {
    //       groups.add(group);
    //     }
    //   }
    //   // print('groups = ' + groups.toString());
    //   return groups;
    // });
    final data = await firebaseFirestore.collection('groups').get();
    List<Group> groups = [];

    for (var document in data.docs) {
      var group = Group.fromMap(document.data());
      if (group.membersUid.contains(auth.currentUser!.uid)) {
        groups.add(group);
      }
    }
    // print('groups = ' + groups.toString());
    return groups;
  }

  Future<bool> getSeenStatus(String messageId, String recieverId) async {
    print('values = ' + recieverId + "   " + messageId);
    final data = await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .doc(messageId)
        .get();
    // print('dat')
    // print('data = ' + data.data()!['isseen'].toString());
    return data.data()!['isseen'];
  }

  Future<String> getGroupUserName(String id) async {
    final name = await firebaseFirestore.collection('users').doc(id).get();

    // print('name = ' + name.data()!['name']);
    return name.data()!['name'];
  }
}
