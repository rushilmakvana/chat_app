// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/config/agora_config.dart';
import 'package:whatsapp_clone/features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final String baseUrl = 'https://whatsapp-clone-videocall.herokuapp.com/';
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: widget.baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : Stack(
              children: [
                AgoraVideoViewer(
                  client: client!,
                  layoutType: Layout.floating,
                  enableHostControls: true, // Add this to enable host controls
                ),
                AgoraVideoButtons(
                  client: client!,
                  disconnectButtonChild: IconButton(
                    icon: const Icon(Icons.call_end),
                    onPressed: () async {
                      await client!.engine.leaveChannel();
                      ref.read(callControllerProvider).endCall(
                            widget.call.callerId,
                            widget.call.recieverId,
                            context,
                          );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
