import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message.dart';

class SenderMessage extends StatelessWidget {
  final String message, date;
  final MessageEnum type;
  final String repliedText;
  final VoidCallback onswipeleft;
  final String senderId;
  final MessageEnum repliesMessageType;
  final bool isGroupChat;
  final String username;
  const SenderMessage({
    required this.username,
    required this.senderId,
    required this.isGroupChat,
    required this.type,
    required this.message,
    required this.date,
    required this.onswipeleft,
    required this.repliedText,
    required this.repliesMessageType,
    // required this.username,
  });

  @override
  Widget build(BuildContext context) {
    // print("dnkjdfkjdhfkjdhf = " + senderId);
    // print("dnkjdfkjdhfkjdhf = " + username);
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      animationDuration: const Duration(milliseconds: 100),
      onRightSwipe: onswipeleft,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
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
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 55, 65, 70),
                              border: Border(
                                left: BorderSide(
                                  color: Colors.purple.shade300,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(username),
                                SizedBox(
                                  height: 0,
                                  child: Opacity(
                                    opacity: 0,
                                    child: Text(message),
                                  ),
                                ),
                                Text(
                                  username,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                DisplayMessage(
                                  isGroupChat: isGroupChat,
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
                        isGroupChat: isGroupChat,
                        message: message,
                        type: type,
                        senderId: senderId,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: type == MessageEnum.text ? 2 : 5,
                  right: type == MessageEnum.text ? 3 : 10,
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
