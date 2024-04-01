import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thewall/auth/auth.dart';
import 'package:thewall/firebase_options.dart';
import 'package:thewall/theme/dark_theme.dart';
import 'package:thewall/theme/light_theme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: AuthPage(),
    );
  }
}