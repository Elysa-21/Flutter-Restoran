import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_flutter/home_page.dart';
import 'package:tugas_flutter/models/cart.dart';
import 'package:tugas_flutter/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class StrukPage extends StatelessWidget {
  final String nama;
  final String metode;
  final List<CartItem> items;
  final String orderId;
  final DateTime transactionTime;

  const StrukPage({
    super.key,
    required this.nama,
    required this.metode,
    required this.items,
    required this.orderId,
    required this.transactionTime,
  });

  // Format waktu
  String get formattedDate =>
      DateFormat('dd/MM/yyyy HH:mm:ss').format(transactionTime);

  // Format Rupiah
  String formatRupiah(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return format.format(amount).replaceAll(',00', '');
  }

  // Simpan order ke SharedPreferences
  Future<void> saveOrderToPrefs(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('order_history');

    List<Map<String, dynamic>> ordersList = [];

    if (existingData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(existingData);
        ordersList = decoded.map((e) => e as Map<String, dynamic>).toList();
      } catch (e) {
        // Handle jika data lama corrupt
        debugPrint('Error decoding order history: $e');
        ordersList = [];
      }
    }

    ordersList.add(order.toMap());

    await prefs.setString('order_history', jsonEncode(ordersList));
  }

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
            Text(
              "ID Pesanan: #$orderId",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text("Tanggal/Waktu: $formattedDate"),
            Text("Nama Pemesan: $nama"),
            Text("Metode Pembayaran: $metode"),
            const Divider(),

            // Daftar item
            Expanded(
              child: ListView(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.menu.nama),
                    subtitle: Text(
                      "${item.quantity} x ${formatRupiah(item.menu.harga)}",
                    ),
                    trailing: Text(
                      formatRupiah(item.menu.harga * item.quantity),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Text(
              "Total: ${formatRupiah(total)}",
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
                onPressed: () async {
                  final cart = Cart();
                  final newOrder = Order(
                    orderId: orderId,
                    customerName: nama,
                    paymentMethod: metode,
                    transactionTime: transactionTime,
                    items: items,
                    totalAmount: total,
                  );

                  // Simpan ke SharedPreferences
                  await saveOrderToPrefs(newOrder);

                  for (var item in items) {
                    cart.removeItem(item.menu);
                  }

                  // Tampilkan SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pesanan berhasil!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Navigasi ke HomePage setelah delay
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HomePage(username: "", email: ""),
                      ),
                      (route) => false,
                    );
                  });
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
