import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/util/constants.dart';
import 'package:chatapp_two/common/util/logger.dart';
import 'package:chatapp_two/config.dart';
import 'package:chatapp_two/features/call/service/call_invitation.dart';
import 'package:chatapp_two/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:chatapp_two/features/startup/pages/startup.dart';

import 'common/util/run_mode.dart';

final Logger logger = AppLogger.getLogger('init');

void main() async {
  logger.i("Initializing app in ${RunModeExtension.currentMode.name} mode");
  await dotenv.load(fileName: '.env');
  final navigatorKey = GlobalKey<NavigatorState>();

  CallInvitationService.attachNavigatorKey(navigatorKey);
  CallInvitationService.useSysCallUI();
  WidgetsFlutterBinding.ensureInitialized();

  if (RunModeExtension.currentMode.isDebug) {
    // https://github.com/flutter/flutter/issues/10713
    // hide keyboard on hot restart
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  await Firebase.initializeApp(
    name: dotenv.get("FIREBASE_PROJECT_ID"),
    options: AppConfig.firebaseSettings,
  );

  runApp(
    ProviderScope(
      observers: [ProviderStateChangeObserver()],
      child: App(navigatorKey: navigatorKey),
    ),
  );
}

class App extends ConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const App({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          themeNotifier == Brightness.light ? ThemeMode.light : ThemeMode.dark,
      onGenerateRoute: PageRouter.generateRoutes,
      home: const StartUp(),
    );
  }
}
