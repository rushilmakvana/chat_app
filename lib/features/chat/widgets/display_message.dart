import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player.dart';

class DisplayMessage extends ConsumerWidget {
  final String message;
  final MessageEnum type;
  bool isGroupChat = false;
  String? senderId;
  DisplayMessage({
    required this.senderId,
    this.isGroupChat = false,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print("name = " + name);
    bool isplaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    // print('display = ' + isGroupChat.toString() + '\n');
    return type == MessageEnum.text
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isGroupChat)
                if (senderId != null)
                  Column(
                    children: [
                      FutureBuilder<String>(
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('');
                          }
                          // print("snapshot name = " + snapshot.data.toString());
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.purple.shade200,
                              // fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                        future: ref
                            .read(chatControllerProvider)
                            .getGroupUserName(senderId!),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          )
        : type == MessageEnum.image
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: message,
                ),
              )
            : type == MessageEnum.audio
                ? StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 80,
                      ),
                      padding: const EdgeInsets.only(bottom: 20, top: 5),
                      onPressed: () async {
                        if (isplaying) {
                          await audioPlayer.pause();
                          setState(() {
                            isplaying = false;
                          });
                        } else {
                          await audioPlayer.play(
                            UrlSource(
                              message,
                            ),
                          );
                          setState(() {
                            isplaying = true;
                          });
                        }
                      },
                      icon: Icon(
                        isplaying ? Icons.pause_circle : Icons.play_circle,
                      ),
                    );
                  })
                : type == MessageEnum.gif
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: message,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomVideoPlayer(
                          videoUrl: message,
                        ),
                      );
  }
}
