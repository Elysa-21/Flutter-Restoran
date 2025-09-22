import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Setelah 3 detik otomatis ke WelcomePage
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("assets/logo.png", width: 300, height: 300),
              ),
              const SizedBox(height: 10),

              // Tulisan "Dapur Mama"
              Text(
                "Dapur Mama",
                style: GoogleFonts.berkshireSwash(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 30),

              // Nama + NIM
              Text(
                "Nama : Elysa Hayu Noorhaini\n"
                "Nim : 24111814078",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),

              const SizedBox(height: 30),

              // Loading indicator muter
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 0, 0),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
