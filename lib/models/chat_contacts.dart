// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatContacts {
  final String name;
  final String lastMessage;
  final String profilePic;
  final String contactId;
  final DateTime timesent;
  final String senderId;
  String? messageId;

  ChatContacts({
    required this.name,
    required this.lastMessage,
    required this.profilePic,
    required this.contactId,
    required this.timesent,
    required this.senderId,
    this.messageId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'lastMessage': lastMessage,
      'profilePic': profilePic,
      'contactId': contactId,
      'timesent': timesent.millisecondsSinceEpoch,
      'senderId': senderId,
      'messageId': messageId,
    };
  }

  factory ChatContacts.fromMap(Map<String, dynamic> map) {
    return ChatContacts(
      name: map['name'],
      lastMessage: map['lastMessage'],
      profilePic: map['profilePic'],
      contactId: map['contactId'],
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent']),
      senderId: map['senderId'],
      messageId: map['messageId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatContacts.fromJson(String source) =>
      ChatContacts.fromMap(json.decode(source) as Map<String, dynamic>);
}
