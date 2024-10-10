import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tailorapp/auth/login_screen.dart';
import 'package:tailorapp/auth/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // // Notification based code

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // // Request permissions to show notifications (iOS only)
  // await messaging.requestPermission();

  // // Optionally: Subscribe to a topic, if needed
  // await messaging.subscribeToTopic('restaurant_notifications');

  // // code ends here......

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: IkChatBotScreen(),
      home: const LoginScreen(),
      routes: {
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
