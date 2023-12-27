import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repositories/storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/status_model.dart';
import 'package:whatsapp_clone/models/user.dart';

final statusRepoProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    print('add status');
    var statusId = const Uuid().v1();
    String uid = auth.currentUser!.uid;

    final imgUrl = await ref.read(firebaseStorageProvider).storeFileToForebase(
          'status/$statusId$uid',
          statusImage,
        );

    final statusMap = {
      'image': imgUrl,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
    // final imgUrl = '';

    List<Contact> contacts = [];
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
    }
    List<String> whoCansee = [];
    List<UserModel> users = [];

    var userData = await firestore.collection('users').get();

    for (var tempuser in userData.docs) {
      var user = UserModel.fromMap(tempuser.data());
      users.add(user);
    }

    for (int i = 0; i < users.length; i++) {
      for (int j = 0; j < contacts.length; j++) {
        if (users[i].phoneNumber ==
            contacts[j].phones[0].number.replaceAll(' ', '')) {
          whoCansee.add(users[i].uid);
        }
      }
    }

    List<Map<String, dynamic>> imgUrls = [];
    var statusSnapsots = await firestore
        .collection('status')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get();
    if (statusSnapsots.docs.isNotEmpty) {
      Status status = Status.fromMap(
        statusSnapsots.docs[0].data(),
      );
      imgUrls = status.photoUrl;
      imgUrls.add(statusMap);
      await firestore
          .collection('status')
          .doc(statusSnapsots.docs[0].id)
          .update({
        'photoUrl': imgUrls,
      });
      return;
    } else {
      imgUrls = [statusMap];
    }
    Status status = Status(
      uid: uid,
      phoneNumber: phoneNumber,
      userName: username,
      photoUrl: imgUrls,
      createdAt: DateTime.now(),
      profilePic: profilePic,
      statusId: statusId,
      whocanSee: whoCansee,
    );

    await firestore.collection('status').doc(statusId).set(
          status.toMap(),
        );
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    List<Status> allStatuses = [];
    // try {
    List<Contact> contacts = [];
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }

    var statuses = await firestore.collection('status').get();
    for (var tempstatus in statuses.docs) {
      Status status = Status.fromMap(tempstatus.data());
      print("statuses = " + status.toString());
      allStatuses.add(status);
    }

    for (int i = 0; i < allStatuses.length; i++) {
      for (int j = 0; j < contacts.length; j++) {
        if (allStatuses[i].phoneNumber ==
                contacts[j].phones[0].number.replaceAll(' ', '') &&
            allStatuses[i].createdAt.millisecondsSinceEpoch >
                DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch) {
          statusData.add(allStatuses[i]);
        }
      }
    }
    // for (int i = 0; i < contacts.length; i++) {
    //   var tempData = await firestore
    //       .collection('status')
    //       .where(
    //         'phoneNumber',
    //         isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
    //       )
    //       .where('createdAt',
    //           isGreaterThan: DateTime.now()
    //               .subtract(const Duration(hours: 24))
    //               .millisecondsSinceEpoch)
    //       .get();

    //   for (var tempStatus in tempData.docs) {
    //     Status status = Status.fromMap(tempStatus.data());

    //     if (status.whocanSee.contains(auth.currentUser!.uid)) {
    //       statusData.add(status);
    //     }
    //   }
    // }
    // } catch (e) {
    //   if (kDebugMode) print(e);
    //   showSnackBar(context: context, content: e.toString());
    // }
    return statusData;
  }
}
