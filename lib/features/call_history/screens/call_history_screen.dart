import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/features/call_history/controller/call_history_controller.dart';

class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<dynamic>>(
        future: ref.read(callHistoryControllerProvider).getCallHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('No calls yet.'),
            );
          }
          // print('snapsot history = ' + snapshot.data.toString());
          // print('snapshot cpunt = ' + snapshot.data!.length.toString());
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: ((context, index) {
              final callData = snapshot.data![index];
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        callData['recieverProfilepic'],
                      ),
                      radius: 30,
                    ),
                    title: Text(
                      callData['caller'] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? callData['recieverName']
                          : callData['callerName'],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Transform.rotate(
                          angle: callData['caller'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? -math.pi / 4
                              : -math.pi / 4,
                          child: Icon(
                            callData['caller'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Icons.arrow_forward
                                : Icons.arrow_back,
                            size: 16,
                            color: callData['hasPicked']
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          DateFormat.MEd().add_jm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  callData['timesent'],
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              );
            }),
          );
        });
  }
}
