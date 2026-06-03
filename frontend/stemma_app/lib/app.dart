import 'package:flutter/material.dart';
import 'package:stemma_app/Features/Splash/splash_page.dart';
import 'package:stemma_app/Features/Splash/welcome_page.dart';

class StemmaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STEMMA',
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
