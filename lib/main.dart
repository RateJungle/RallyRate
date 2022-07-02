import 'package:flutter/material.dart';
import 'package:rally_rate/screens/app_auth/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rally_rate/screens/app_navigation/write_screen.dart';
import 'package:rally_rate/screens/splash_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

