import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void SelectContact(Contact contact, BuildContext context) async {
    try {
      var usercollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in usercollection.docs) {
        var userdata = UserModel.fromMap(document.data());
        if (contact.phones[0].number == userdata.phoneNumber) {
          isFound = true;
        }
        // print('contacts  =' + contact.phones[0].number.toString());
        if (isFound == true) {
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userdata.name,
            'uid': userdata.uid,
            'isGroupChat': false,
            'profilePic': userdata.profilepic,
          });
          return;
        }
      }
      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'Number does not found in the app',
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
