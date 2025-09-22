import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/bg_welcome.png",
                  ), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 7, 
                    child: Image.asset(
                      "assets/makanan_welcome.png",
                      fit: BoxFit.contain, 
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),

                  // Judul
                  Text(
                    "Dapur Mama",
                    style: GoogleFonts.berkshireSwash(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 33
                          : 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),

                  // Subjudul 1
                  Text(
                    "Citarasa Rumahan, Sajian Istimewa!",
                    style: GoogleFonts.robotoSlab(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 16
                          : 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Subjudul 2 tambahan
                  Text(
                    "Nikmati Setiap Suapan Kelezatan Yang Mengingatkanmu Pada Masakan Ibu di Dapur Mama...",
                    style: GoogleFonts.robotoSlab(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 14
                          : 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tombol Login
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.orange.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Tombol Sign Up
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.orange.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
