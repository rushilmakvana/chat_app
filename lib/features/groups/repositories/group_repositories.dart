import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repositories/storage_repository.dart';
import 'package:whatsapp_clone/models/groups.dart' as model;
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user.dart';

final groupRepoProvider = Provider((ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  FirebaseFirestore firestore;
  FirebaseAuth auth;
  ProviderRef ref;
  GroupRepository(
      {required this.firestore, required this.auth, required this.ref});
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    List<UserModel> usermodel = [];
    var allContacts = await FlutterContacts.getContacts(withProperties: true);
    // for (int i = 0; i < allContacts.length; i++) {
    //   print(
    //       'contacts = ' + allContacts[i].phones[0].number.replaceAll(' ', ''));
    // }
    // print('all contacts = ' + allContacts.toString());
    var users = await firestore
        .collection('users')
        .where('uid', isNotEqualTo: auth.currentUser!.uid)
        .get();
    for (var document in users.docs) {
      usermodel.add(
        UserModel.fromMap(
          document.data(),
        ),
      );
    }
    // print('auth = ' + auth.currentUser!.uid);
    for (int i = 0; i < usermodel.length; i++) {
      // print("user phone = " + usermodel[i].phoneNumber);
      for (int j = 0; j < allContacts.length; j++) {
        if (usermodel[i].phoneNumber ==
            allContacts[j].phones[0].number.replaceAll(' ', '')) {
          contacts.add(allContacts[j]);
        }
      }
    }
    return contacts;
  }

  void createGroup(BuildContext context, String name, File file,
      List<Contact> contacts) async {
    try {
      List<String> uids = [];
      List<UserModel> users = [];
      var usersData = await firestore.collection('users').get();

      for (var document in usersData.docs) {
        users.add(UserModel.fromMap(document.data()));
      }

      for (int i = 0; i < users.length; i++) {
        for (int j = 0; j < contacts.length; j++) {
          if (users[i].phoneNumber ==
              contacts[j].phones[0].number.replaceAll(' ', '')) {
            uids.add(users[i].uid);
          }
        }
      }
      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(firebaseStorageProvider)
          .storeFileToForebase('groups/$groupId', file);

      model.Group group = model.Group(
        groupId: groupId,
        groupPic: profileUrl,
        lastMessage: '',
        membersUid: [auth.currentUser!.uid, ...uids],
        name: name,
        senderId: auth.currentUser!.uid,
        timesent: DateTime.now(),
        senderName: '',
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
