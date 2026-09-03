import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xff2962FF),
              child: Icon(
                Icons.inventory_2_outlined,
                color: Colors.white,
                size: 55,
              ),
            ),

            SizedBox(height: 25),

            Text(
              "Inventory\nManagement",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Loading...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 35),

            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}