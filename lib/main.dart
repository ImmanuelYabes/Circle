import 'package:circle/constant/constant_builder.dart';
import 'package:circle/view/authentication/login.dart';
import 'package:circle/view/master.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'constant/firebase_constant.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    return MaterialApp(
      title: 'Circle',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.deepPurple,
      ),
      home: (user != null)
            ? MasterPage(user)
            : const LoginPage()
    );
  }
}
