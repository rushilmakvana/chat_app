import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message.dart';
import '../../.././providers/message_reply_provider.dart';

class ReplyMessage extends ConsumerWidget {
  // String? receiverName;

  // ReplyMessage({this.receiverName});
  @override
  void cancelReply(WidgetRef ref) {
    final reply = ref.watch(messageReplyProvider.state).update((state) => null);
  }

  Widget build(BuildContext context, WidgetRef ref) {
    final reply = ref.watch(messageReplyProvider);
    return Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      padding: const EdgeInsets.all(10).copyWith(bottom: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          10,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 28, 39, 48),
            border: Border(
              left: BorderSide(
                color: tabColor,
                width: 5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      reply!.isMe ? 'You' : 'Opposite',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 16,
                    ),
                    onTap: () {
                      cancelReply(ref);
                      TempUserName.setName(null);
                      // print("dfdfdfdffdfdf = " + TempUserName.name.toString());
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              DisplayMessage(
                message: reply.message,
                type: reply.messageEnum,
                senderId: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
