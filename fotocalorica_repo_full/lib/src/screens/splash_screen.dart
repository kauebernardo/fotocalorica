import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  void _goNext() async {
    await Future.delayed(Duration(milliseconds: 900));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OnboardingScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('FotoCalórica', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
    );
  }
}
