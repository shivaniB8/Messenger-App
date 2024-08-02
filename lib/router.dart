import 'dart:io';

import 'package:chatapp_two/features/ids/screens/my_ids.dart';
import 'package:chatapp_two/features/profile/screens/profile_screen.dart';
import 'package:chatapp_two/features/profile/screens/user_profile_screen.dart';
import 'package:chatapp_two/features/qr/screens/qr_details_screen.dart';
import 'package:chatapp_two/features/qr/screens/qr_view.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_two/common/models/call.dart';
import 'package:chatapp_two/common/models/status.dart';
import 'package:chatapp_two/common/util/logger.dart';
import 'package:chatapp_two/features/auth/pages/create_profile.dart';
import 'package:chatapp_two/features/auth/pages/login.dart';
import 'package:chatapp_two/features/auth/pages/otp_verification.dart';
import 'package:chatapp_two/features/call/pages/call.dart';
import 'package:chatapp_two/features/chat/pages/chat_room.dart';
import 'package:chatapp_two/features/contact/pages/select_contact.dart';
import 'package:chatapp_two/features/group/pages/create_group.dart';
import 'package:chatapp_two/features/home/pages/home.dart';
import 'package:chatapp_two/features/status/pages/status_image_preview.dart';
import 'package:chatapp_two/features/status/pages/status_view.dart';
import 'package:chatapp_two/features/status/pages/status_writer.dart';
import 'package:chatapp_two/features/welcome/pages/welcome.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PageRouter {
  static const String welcome = '/welcome';
  static const String login = 'auth/login';
  static const String otpVerification = 'auth/otp-verification';
  static const String createProfile = 'auth/create-profile';
  static const String home = "/home";
  static const String selectContact = "/select-contact";
  static const String chat = "/chat";
  static const String statusWriter = "/status-writer";
  static const String statusViewer = "/status-viewer";
  static const String statusImageConfirm = "/status-image-confirm";
  static const String createGroup = "/create-group";
  static const String call = "/call";
  static const String profile = "/profile";
  static const String userProfile = "/user-profile";
  static const String qrDetailsScreen = "/qr-details-screen";
  static const String idsListScreen = "/ids-list-screen";
  static const String qrViewScreen = "/qr_view";

  static Route<Widget> generateRoutes(RouteSettings settings) {
    AppLogger.getLogger((PageRouter).toString())
        .d('Navigating to ${settings.name}');
    switch (settings.name) {
      case welcome:
        return _createRoute(const WelcomePage());
      case login:
        return _createRoute(const LoginPage());
      case otpVerification:
        final String idSent = settings.arguments as String;
        return _createRoute(OTPVerificationPage(idSent: idSent));
      case createProfile:
        return _createRoute(const CreateProfilePage());
      case home:
        return _createRoute(const HomePage());
      case selectContact:
        return _createRoute(const SelectContactPage());
      case chat:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(ChatRoomPage(
          mobileNo: args['phoneNumber'] as String,
          streamId: args['streamId'] as String,
          avatarImage: args['avatarImage'] as String,
          isGroup: args['isGroup'] as bool,
          name: args['name'] as String,
        ));
      case statusWriter:
        return _createRoute(const StatusWriterPage());
      case statusViewer:
        final status = settings.arguments as StatusModel;
        return _createRoute(StatusViewerPage(status: status));
      case statusImageConfirm:
        final file = settings.arguments as File;
        return _createRoute(StatusImageConfirmPage(file: file));
      case createGroup:
        return _createRoute(const CreateGroupPage());
      case call:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(
          CallPage(
            channelId: args['channelId'] as String,
            model: args['model'] as CallModel,
            isGroup: args['isGroup'] as bool,
          ),
        );

      case profile:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(ProfileScreen(
          mobileNo: args['phoneNumber'] as String,
          roomAvatar: args['avatarImage'] as String,
          userName: args['userName'] as String,
        ));
      case userProfile:
        // final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(const UserProfileScreen());
      case idsListScreen:
        // final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(const MyIdsScreen());

      case qrDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(QrDetailsScreen(
            name: args['name'] as String,
            resident: args['resident'] as String,
            gender: args['gender'] as String,
            documents: args['documents'] as List<String>));
      case qrViewScreen:
        // final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(const QRViewExample());

      default:
        return _createRoute(UnknownRoutePage(targetRoute: settings.name!));
    }
  }

  static Route<Widget> _createRoute(Widget child) {
    return MaterialPageRoute<Widget>(
      builder: (_) => child,
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  final String targetRoute;

  const UnknownRoutePage({
    super.key,
    required this.targetRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "The route '$targetRoute' was not found.",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
