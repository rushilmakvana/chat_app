import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/features/groups/screens/create_group_screen.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_status.dart';
import 'package:whatsapp_clone/features/status/screens/view_status.dart';
import 'package:whatsapp_clone/models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        settings: settings,
      );
    case UserInfoScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
        settings: settings,
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => SelectContactScreen(),
        settings: settings,
      );
    case OtpScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            OtpScreen(verificationId: settings.arguments as String),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    case ConfirmStatus.routeName:
      final file = settings.arguments;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ConfirmStatus(
          file: file as File,
        ),
      );
    case ViewStory.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ViewStory(
          status: status,
        ),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: ErrorScreen(
            errorText: 'Page does not exists',
          ),
        ),
      );
  }
}
