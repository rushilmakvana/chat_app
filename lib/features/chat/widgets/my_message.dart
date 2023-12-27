import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message.dart';
// import 'package:whatsapp_clone/info.dart';

class MyMessage extends ConsumerWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final String repliedText;
  final VoidCallback onswipeleft;
  final String username;
  final MessageEnum repliesMessageType;
  final bool isSeen;

  const MyMessage({
    required this.type,
    required this.message,
    required this.date,
    required this.onswipeleft,
    required this.repliedText,
    required this.repliesMessageType,
    required this.username,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onswipeleft,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
            minWidth: 100,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                          bottom: 20,
                        )
                      : const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 5
                          // bottom: 20,
                          ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isReplying) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          child: Container(
                            // margin: EdgeInsets.only(bottom: 5,),
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 12, 114, 115),
                              border: Border(
                                left: BorderSide(
                                  color: tabColor,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 0,
                                  child: Opacity(
                                    opacity: 0,
                                    child: Text(message),
                                  ),
                                ),
                                // DisplayMessage(message: message, type: type),
                                Text(
                                  username,
                                ),

                                const SizedBox(
                                  height: 2,
                                ),
                                DisplayMessage(
                                  message: repliedText,
                                  type: repliesMessageType,
                                  senderId: null,
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        // if (1 == 0)
                        //   DisplayMessage(message: message, type: type),
                      ],
                      DisplayMessage(
                        message: message,
                        type: type,
                        senderId: null,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: type == MessageEnum.text ? 0 : 5,
                  right: type == MessageEnum.text ? 5 : 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 20,
                        color: isSeen ? Colors.blue : Colors.white60,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
