import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/repositories/storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/screens/mobile_layout.dart';

final authRepoProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  void SignInWithPhone(
      {required String number, required BuildContext context}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: ((phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        }),
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.pushNamed(context, OtpScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void varifyOtp({
    required BuildContext context,
    required String verificationId,
    required String otp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInfoScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserData({
    required BuildContext context,
    required File? profilePic,
    required ProviderRef ref,
    required String name,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://www.portmelbournefc.com.au/wp-content/uploads/2022/03/avatar-1.jpeg';

      if (profilePic != null) {
        photoUrl = await ref
            .read(firebaseStorageProvider)
            .storeFileToForebase('profilePic/$uid', profilePic);
      }
      final user = UserModel(
        name: name,
        uid: uid,
        profilepic: photoUrl,
        isOnline: true,
        groupId: [],
        phoneNumber: auth.currentUser!.phoneNumber as String,
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MobileLayout(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    // print('user data = ' + userData.data().toString());

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userData(String uid) {
    // print('called');
    final data = firestore.collection('users').doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data()!),
        );
    // print('data = ' + data.toString());
    return data;
  }

  void setUserState(bool isonline) async {
    firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isonline,
    });
  }
}
