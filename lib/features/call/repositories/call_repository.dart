import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/models/call_history.dart';
import 'package:whatsapp_clone/models/groups.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/call/screens/call_screen.dart';
import 'package:whatsapp_clone/models/call.dart';

final CallRepositoryProvider = Provider(
  (ref) => CallRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class CallRepository {
  FirebaseAuth auth;
  FirebaseFirestore firestore;

  CallRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCalls(
      Call senderCallData, BuildContext context, Call recieverCallData) async {
    try {
      final timesent = DateTime.now();
      final String id = const Uuid().v1();
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.recieverId)
          .set(recieverCallData.toMap());

      var userData = await firestore
          .collection('callHistory')
          .doc(auth.currentUser!.uid)
          .get();
      var Data = CallHistory(history: [
        History(
          hasPicked: true,
          caller: auth.currentUser!.uid,
          reciever: senderCallData.recieverId,
          callerName: senderCallData.callerName,
          recieverName: senderCallData.recieverName,
          callerProfilepic: senderCallData.callerPic,
          recieverProfilepic: senderCallData.recieverPic,
          timesent: timesent,
          id: id,
        )
      ]);
      var newData = History(
        id: id,
        hasPicked: true,
        caller: senderCallData.callerId,
        reciever: senderCallData.recieverId,
        callerProfilepic: senderCallData.callerPic,
        recieverProfilepic: senderCallData.recieverPic,
        callerName: senderCallData.callerName,
        recieverName: senderCallData.recieverName,
        timesent: timesent,
      );
      if (!userData.exists) {
        await firestore
            .collection('callHistory')
            .doc(auth.currentUser!.uid)
            .set(Data.toMap());
      } else {
        List<History> history = [];
        var data = await firestore
            .collection('callHistory')
            .doc(auth.currentUser!.uid)
            .get();
        for (var document in data.data()!['history']) {
          history.add(History.fromMap(document));
        }
        history.add(newData);
        await firestore
            .collection('callHistory')
            .doc(auth.currentUser!.uid)
            .update({
          'history': history.map((e) => e.toMap()).toList(),
        });
        // await firestore
        //     .collection('callHistory')
        //     .doc(senderCallData.recieverId)
        //     .update({
        //   'history': history.map((e) => e.toMap()).toList(),
        // });
      }
      //-------------------------------
      var data = await firestore
          .collection('callHistory')
          .doc(senderCallData.recieverId)
          .get();
      if (!data.exists) {
        await firestore
            .collection('callHistory')
            .doc(senderCallData.recieverId)
            .set(Data.toMap());
      } else {
        List<History> history = [];
        var data = await firestore
            .collection('callHistory')
            .doc(senderCallData.recieverId)
            .get();
        for (var document in data.data()!['history']) {
          history.add(History.fromMap(document));
        }
        history.add(newData);
        await firestore
            .collection('callHistory')
            .doc(senderCallData.recieverId)
            .update({
          'history': history.map((e) => e.toMap()).toList(),
        });
      }
      //------------------------------------
      // print('userdata = ' + userData.exists.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: false,
          );
        }),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCalls(
      Call senderCallData, BuildContext context, Call recieverCallData) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      var snapshot = await firestore
          .collection('groups')
          .doc(senderCallData.recieverId)
          .get();
      model.Group group = model.Group.fromMap(snapshot.data()!);

      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).set(
              recieverCallData.toMap(),
            );
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: true,
          );
        }),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(
      String calllerId, String recieverId, BuildContext context) async {
    try {
      await firestore.collection('call').doc(calllerId).delete();
      await firestore.collection('call').doc(recieverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
      String calllerId, String recieverId, BuildContext context) async {
    try {
      await firestore.collection('call').doc(calllerId).delete();
      var snapshot = await firestore.collection('groups').doc(recieverId).get();
      model.Group group = model.Group.fromMap(snapshot.data()!);

      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void denyCall(
    String callerId,
    String recieverId,
    BuildContext context,
  ) async {
    try {
      var senderdata =
          await firestore.collection('callHistory').doc(callerId).get();
      List<History> tempArray = [];
      for (var document in senderdata.data()!['history']) {
        tempArray.add(History.fromMap(document));
        // print('data = = ' + document.toString());
      }
      // print('temparray = ' + tempArray.runtimeType.toString());
      var lastEle = tempArray[tempArray.length - 1];
      // print('last ele = ' + lastEle.hasPicked.toString());
      var newHisoty = History(
        caller: lastEle.caller,
        reciever: lastEle.reciever,
        callerProfilepic: lastEle.callerProfilepic,
        recieverProfilepic: lastEle.recieverProfilepic,
        callerName: lastEle.callerName,
        recieverName: lastEle.recieverName,
        timesent: lastEle.timesent,
        hasPicked: false,
        id: lastEle.id,
      );
      tempArray[tempArray.length - 1] = newHisoty;
      await firestore.collection('callHistory').doc(callerId).set({
        'history': tempArray.map((e) => e.toMap()).toList(),
      });

      var recieverData =
          await firestore.collection('callHistory').doc(recieverId).get();
      List<History> recieverTempArray = [];

      for (var document in recieverData.data()!['history']) {
        recieverTempArray.add(History.fromMap(document));
      }
      var recieverLastEle = recieverTempArray[recieverTempArray.length - 1];
      var rNewHisoty = History(
        caller: recieverLastEle.caller,
        reciever: recieverLastEle.reciever,
        callerProfilepic: recieverLastEle.callerProfilepic,
        recieverProfilepic: recieverLastEle.recieverProfilepic,
        callerName: recieverLastEle.callerName,
        recieverName: recieverLastEle.recieverName,
        timesent: recieverLastEle.timesent,
        hasPicked: false,
        id: recieverLastEle.id,
      );
      recieverTempArray[recieverTempArray.length - 1] = rNewHisoty;
      await firestore.collection('callHistory').doc(recieverId).set({
        'history': recieverTempArray.map((e) => e.toMap()).toList(),
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
