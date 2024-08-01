// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_to_do_app/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 50), () => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('img/logo.png')),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 50,
            height: 3,
            child: LinearProgressIndicator(
              backgroundColor: Color.fromARGB(255, 50, 194, 251),
            ),
          ),
        ],
      ),
    );
  }
}
