import 'package:flutter/material.dart';
import 'package:classmate/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClassMateApp());
}

class ClassMateApp extends StatelessWidget {
  const ClassMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ClassMate',
      // theme: ThemeData().copyWith(),
      home: Home(),
    );
  }
}
