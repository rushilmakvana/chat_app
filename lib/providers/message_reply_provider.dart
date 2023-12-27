import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;
  String? username;

  MessageReply(this.isMe, this.message, this.messageEnum, {this.username});
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);

class TempUserName {
  static String? name;

  static void setName(n) {
    name = n;
  }

  String get tempuserName {
    return name ?? '';
  }
}

// final tempUserProvider = StateProvider<String?>((ref) => null);
