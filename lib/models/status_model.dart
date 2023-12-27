// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Status {
  final String uid;
  final String phoneNumber;
  final String userName;
  final List<Map<String, dynamic>> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whocanSee;
  Status({
    required this.uid,
    required this.phoneNumber,
    required this.userName,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whocanSee,
  });

  // Status({
  //   required this.uid,
  //   required this.phoneNumber,
  //   required this.userName,
  //   required this.photoUrl,
  //   required this.createdAt,
  //   required this.profilePic,
  //   required this.statusId,
  //   required this.whocanSee,
  // });

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'uid': uid,
  //     'phoneNumber': phoneNumber,
  //     'userName': userName,
  //     'photoUrl': photoUrl,
  //     'createdAt': createdAt.millisecondsSinceEpoch,
  //     'profilePic': profilePic,
  //     'statusId': statusId,
  //     'whocanSee': whocanSee,
  //   };
  // }

  // factory Status.fromMap(Map<String, dynamic> map) {
  //   return Status(
  //     uid: map['uid'] as String,
  //     phoneNumber: map['phoneNumber'] as String,
  //     userName: map['userName'] as String,
  //     photoUrl: List<String>.from((map['photoUrl'])),
  //     createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
  //     profilePic: map['profilePic'],
  //     statusId: map['statusId'],
  //     whocanSee: List<String>.from(
  //       (map['whocanSee']),
  //     ),
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whocanSee': whocanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'],
      phoneNumber: map['phoneNumber'],
      userName: map['userName'],
      photoUrl: List<Map<String, dynamic>>.from(
        map['photoUrl'].map<Map<String, dynamic>>(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      profilePic: map['profilePic'],
      statusId: map['statusId'],
      whocanSee: List<String>.from((map['whocanSee'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Status.fromJson(String source) =>
      Status.fromMap(json.decode(source) as Map<String, dynamic>);
}
