// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_clone/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String revieverId;
  final String text;
  final MessageEnum type;
  final DateTime timesent;
  final String messageId;
  final bool isseen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedTexttype;

  Message({
    required this.senderId,
    required this.revieverId,
    required this.text,
    required this.type,
    required this.timesent,
    required this.messageId,
    required this.isseen,
    required this.repliedMessage,
    required this.repliedTexttype,
    required this.repliedTo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'revieverId': revieverId,
      'text': text,
      'type': type.type,
      'timesent': timesent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isseen': isseen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedTexttype': repliedTexttype.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      revieverId: map['revieverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent'] as int),
      messageId: map['messageId'] as String,
      isseen: map['isseen'] as bool,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedTexttype: (map['repliedTexttype'] as String).toEnum(),
    );
  }
}
