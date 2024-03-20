import 'package:classmate/login.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAppCheck.instance.activate();
  runApp(const ClassMateApp());
}

class ClassMateApp extends StatefulWidget {
  const ClassMateApp({super.key});

  State<ClassMateApp> createState() => _ClassmateAppState();
}

class _ClassmateAppState extends State<ClassMateApp> {
  Future<void> init() async {
    String token = await FirebaseAppCheck.instance.getToken() ?? "";
    print("Token : $token");
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ClassMate',
      home: Login(),
    );
  }
}
