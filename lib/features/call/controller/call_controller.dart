// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/call/repositories/call_repository.dart';
import 'package:whatsapp_clone/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(CallRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    ref: ref,
    auth: FirebaseAuth.instance,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController(
      {required this.callRepository, required this.ref, required this.auth});

  void makeCall(BuildContext context, String recieverName, String recieverUid,
      String recieverProfilePic, bool isGroupChat) {
    String callId = const Uuid().v1();
    ref.read(userDataAuthProvider).whenData((value) {
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilepic,
        recieverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: true,
      );
      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilepic,
        recieverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      if (isGroupChat) {
        callRepository.makeGroupCalls(
            senderCallData, context, recieverCallData);
      } else {
        callRepository.makeCalls(senderCallData, context, recieverCallData);
      }
      // Call senderCallData;
    });
  }

  void endCall(String callerId, String recieverId, BuildContext context) {
    callRepository.endCall(callerId, recieverId, context);
  }

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void denyCall(
    String callerId,
    String recieverId,
    BuildContext context,
  ) {
    callRepository.denyCall(callerId, recieverId, context);
  }
}
