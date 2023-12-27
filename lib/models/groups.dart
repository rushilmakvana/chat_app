import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final DateTime timesent;
  final List<String> membersUid;
  final String senderName;

  Group({
    required this.senderName,
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timesent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'timesent': timesent.millisecondsSinceEpoch,
      'membersUid': membersUid,
      'senderName': senderName,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'],
      name: map['name'],
      groupId: map['groupId'],
      lastMessage: map['lastMessage'],
      groupPic: map['groupPic'],
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent']),
      membersUid: List<String>.from(
        (map['membersUid']),
      ),
      senderName: map['senderName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) =>
      Group.fromMap(json.decode(source) as Map<String, dynamic>);
}
