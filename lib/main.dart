import 'package:classmate/login.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:classmate/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(const ClassMateApp());
}

class ClassMateApp extends StatelessWidget {
  const ClassMateApp({super.key});

  Future<void> init() async {
    String token = await FirebaseAppCheck.instance.getToken() ?? "";
    print("Token : $token");
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ClassMate',
      // theme: ThemeData().copyWith(),
      home: Login(),
    );
  }
}
