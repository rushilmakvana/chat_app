// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final callHistoryRepoProvider = Provider(
  (ref) => CallHistoryRepo(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallHistoryRepo {
  FirebaseFirestore firestore;
  FirebaseAuth auth;
  CallHistoryRepo({
    required this.firestore,
    required this.auth,
  });

  Future<List<dynamic>> getcallHistory() async {
    final data = await firestore
        .collection('callHistory')
        .doc(auth.currentUser!.uid)
        .get();
    var history = data.data()!['history'];
    // print('data history = ' + history.runtimeType.toString());
    return history;
  }
}
