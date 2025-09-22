import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_flutter/models/menu.dart';
import 'package:tugas_flutter/models/cart.dart';

class DetailMenuPage extends StatelessWidget {
  final Menu menu;

  const DetailMenuPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menu.nama),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Menu
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  menu.gambar,
                  width: 260,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fastfood, size: 80, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nama & Kategori
            Text(
              menu.nama,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              menu.kategori,
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),

            // Harga
            Text(
              menu.hargaFormatted,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Deskripsi",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              menu.deskripsi(),
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Cart().addItem(menu);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${menu.nama} ditambahkan ke keranjang."),
                      backgroundColor: Colors.deepOrange,
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text(
                  "Tambah Keranjang",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
