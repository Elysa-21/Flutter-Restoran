import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_flutter/home_page.dart';
import 'package:tugas_flutter/models/cart.dart';

class StrukPage extends StatelessWidget {
  final String nama;
  final String metode;
  final List<CartItem> items;

  StrukPage({
    super.key,
    required this.nama,
    required this.metode,
    required this.items,
  }) : assert(nama.trim().isNotEmpty, 'Nama pemesan harus diisi');

  @override
  Widget build(BuildContext context) {
    final total = items.fold(0, (sum, item) => sum + item.totalPrice);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Struk Pembelian"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dapur Mama",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("Nama Pemesan: $nama"),
            Text("Metode Pembayaran: $metode"),
            const Divider(),

            // Daftar item
            Expanded(
              child: ListView(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.menu.nama),
                    subtitle: Text("${item.quantity} x ${item.menu.harga}"),
                    trailing: Text(
                      "Rp ${(item.menu.harga * item.quantity).toString()}",
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(),
            Text(
              "Total: Rp $total",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),

            const SizedBox(height: 10),
            Text(
              "Harap Tunjukkan Struk ke Kasir Saat Pembayaran",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  final cart = Cart();
                  for (var item in items) {
                    cart.removeItem(item.menu); 
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(username: "User  "),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Selesai",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
