import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageProvider = Provider(
  ((ref) => FirebaseStorageRepository(
        firebaseStorage: FirebaseStorage.instance,
      )),
);

class FirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  FirebaseStorageRepository({required this.firebaseStorage});

  Future<String> storeFileToForebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
