import 'dart:async';
import 'package:chatapp/feature/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
      Timer(const Duration(seconds: 3), () => Get.off(()=> user != null ? HomeScreen() : LoginScreen()));
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/auth/chat-bubble-left-right.png"),
            Text("Chatting",style: GoogleFonts.mulish(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),),
          ],
        ),
      ),
    );
  }
}
