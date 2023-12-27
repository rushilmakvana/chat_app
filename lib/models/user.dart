// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final String uid;
  final String profilepic;
  final String phoneNumber;
  final bool isOnline;
  final List<String> groupId;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilepic,
    required this.isOnline,
    required this.groupId,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilepic': profilepic,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilepic: map['profilepic'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isOnline: map['isOnline'] as bool,
      groupId: List<String>.from((map['groupId'])),
    );
  }
}
