import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_reply_widget.dart';
import 'package:whatsapp_clone/providers/message_reply_provider.dart';

class BottomChatField extends ConsumerStatefulWidget {
  
  final String recieverId;
  final bool isGroupChat;
  const BottomChatField({required this.isGroupChat, required this.recieverId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  
  final _messageController = TextEditingController();
  FlutterSoundRecorder? flutterSoundRecorder;
  FocusNode focusNode = FocusNode();
  bool showSendBtn = false;
  bool isShowEmoji = false;
  bool isRecordingInit = false;
  bool isRecording = false;

  void hideEmoji() {
    setState(() {
      isShowEmoji = false;
    });
  }

  void showEmoji() {
    setState(() {
      isShowEmoji = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiContainer() {
    if (isShowEmoji) {
      hideEmoji();
      showKeyboard();
    } else {
      showEmoji();
      hideKeyboard();
    }
  }

  void sendTextMessage() async {
    if (showSendBtn) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text,
            recieverId: widget.recieverId,
            isGroupChat: widget.isGroupChat,
          );
      _messageController.text = '';
      setState(() {});
    } else {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecordingInit) {
        return;
      }
      if (isRecording) {
        await flutterSoundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await flutterSoundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void pickImage() async {
    File? image = await pickImageFromGallary(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
        context, file, widget.recieverId, messageEnum, widget.isGroupChat);
  }

  void pickVideo() async {
    File? video = await pickVideoFromGallary(context);

    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    GiphyGif? gif = await pickGIF(context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          .sendGif(context, gif.url!, widget.recieverId, widget.isGroupChat);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterSoundRecorder = FlutterSoundRecorder();
    opneAudio();
  }

  void opneAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('microphone permission denied');
    }
    await flutterSoundRecorder!.openRecorder();
    isRecordingInit = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
    flutterSoundRecorder!.closeRecorder();
    isRecordingInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isReplying = messageReply != null;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  isReplying ? ReplyMessage() : const SizedBox(),
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 5),
                    decoration: BoxDecoration(
                      color: appBarColor,
                      borderRadius: BorderRadius.only(
                        topLeft: isReplying
                            ? Radius.zero
                            : const Radius.circular(
                                40,
                              ),
                        topRight: isReplying
                            ? Radius.zero
                            : const Radius.circular(
                                40,
                              ),
                        bottomRight: isReplying
                            ? const Radius.circular(20)
                            : const Radius.circular(40),
                        bottomLeft: isReplying
                            ? const Radius.circular(20)
                            : const Radius.circular(40),
                      ),
                    ),
                    child: TextField(
                      onTap: () => setState(() {
                        hideEmoji();
                        showKeyboard();
                      }),
                      focusNode: focusNode,
                      controller: _messageController,
                      onChanged: ((value) {
                        if (value.trim().isNotEmpty) {
                          setState(() {
                            showSendBtn = true;
                          });
                        } else {
                          setState(() {
                            showSendBtn = false;
                          });
                        }
                      }),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(style: BorderStyle.none, width: 0),
                        ),
                        contentPadding: const EdgeInsets.only(top: 10),
                        prefixIcon: SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: toggleEmojiContainer,
                                child: Icon(
                                  isShowEmoji
                                      ? Icons.keyboard
                                      : Icons.emoji_emotions_outlined,
                                ),
                              ),
                              GestureDetector(
                                onTap: selectGIF,
                                child: const Icon(
                                  Icons.gif_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        suffixIcon: SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: pickImage,
                                child: const Icon(
                                  Icons.camera_alt,
                                ),
                              ),
                              GestureDetector(
                                onTap: pickVideo,
                                child: const Icon(
                                  Icons.attach_file_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0, right: 2, left: 5),
              child: GestureDetector(
                onTap: sendTextMessage,
                child: CircleAvatar(
                  backgroundColor: const Color(0xff128c7e),
                  radius: 25,
                  child: Icon(
                    showSendBtn == true
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        isShowEmoji
            ? SizedBox(
                height: 280,
                child: EmojiPicker(
                  config: Config(
                    bgColor: ThemeData.dark().primaryColor,
                  ),
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text += emoji.emoji;
                    });

                    if (!showSendBtn) {
                      setState(() {
                        showSendBtn = true;
                      });
                    }
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
