// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/call_history/repositories/call_history.dart';

final callHistoryControllerProvider = Provider((ref) {
  final callHistoryRepo = ref.read(callHistoryRepoProvider);
  return CallHistoryController(callHistoryRepo: callHistoryRepo);
});

class CallHistoryController {
  CallHistoryRepo callHistoryRepo;
  CallHistoryController({
    required this.callHistoryRepo,
  });

  Future<List<dynamic>> getCallHistory() async {
    // print('called');
    final data = await callHistoryRepo.getcallHistory();
    // print("here = " + data.toString());
    return data.reversed.toList();
  }
}
