import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/repositories/auth_repository.dart';
import 'package:whatsapp_clone/models/user.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepoProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.authRepository, required this.ref});

  void signinWithPhone(BuildContext context, String phoneNum) {
    // print('called');
    // print(phoneNum);
    authRepository.SignInWithPhone(number: phoneNum, context: context);
  }

  void verifyOtp(BuildContext context, String verificationId, String userOtp) {
    authRepository.varifyOtp(
        context: context, verificationId: verificationId, otp: userOtp);
  }

  void saveuserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepository.saveUserData(
        context: context, profilePic: profilePic, ref: ref, name: name);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    // print('userdata = ' + user.toString());
    return user;
  }

  Stream<UserModel> userDataById(String uid) {
    return authRepository.userData(uid);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
