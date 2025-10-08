import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_flutter/models/cart.dart';
import 'package:tugas_flutter/struk_page.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'dart:math'; // Untuk random ID
import 'package:tugas_flutter/models/order.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> items;
  final void Function(Order) onOrderAdded; // Callback to add order

  const CheckoutPage({
    super.key,
    required this.items,
    required this.onOrderAdded,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _namaController = TextEditingController();
  String _metodePembayaran = "Cash";

  // Membuat ID Pesanan unik
  String generateOrderId() {
    final now = DateTime.now();
    final timeStamp = DateFormat('yyyyMMddHHmmss').format(now);
    final random = Random();
    final uniqueSuffix = random.nextInt(9000) + 1000; // 1000-9999
    return "DM-$timeStamp-$uniqueSuffix";
  }

  @override
  Widget build(BuildContext context) {
    // Format Rupiah
    String formatRupiah(int amount) {
      final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return format.format(amount).replaceAll(',00', '');
    }

    final total = widget.items.fold(0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...widget.items.map((item) {
                    return ListTile(
                      title: Text(
                        item.menu.nama,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "${item.quantity} x ${formatRupiah(item.menu.harga)}",
                      ),
                      trailing: Text(
                        formatRupiah(item.menu.harga * item.quantity),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    );
                  }),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      formatRupiah(total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: "Nama Pemesan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _metodePembayaran,
              decoration: const InputDecoration(
                labelText: "Metode Pembayaran",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Cash", child: Text("Cash")),
                DropdownMenuItem(value: "Transfer", child: Text("Transfer")),
              ],
              onChanged: (val) {
                setState(() {
                  _metodePembayaran = val!;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  if (_namaController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nama pemesan harus diisi!'),
                      ),
                    );
                    return;
                  }

                  final newOrderId = generateOrderId();
                  final currentTime = DateTime.now();
                  final selectedItems = List<CartItem>.from(widget.items);

                  // Create new order
                  final newOrder = Order(
                    orderId: newOrderId,
                    customerName: _namaController.text.trim(),
                    paymentMethod: _metodePembayaran,
                    transactionTime: currentTime,
                    items: selectedItems,
                    totalAmount: total,
                  );

                  // Use callback to add order
                  widget.onOrderAdded(newOrder);

                  // Kosongkan keranjang
                  final cart = Cart();
                  cart.clear();

                  // Navigasi ke StrukPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StrukPage(
                        nama: _namaController.text.trim(),
                        metode: _metodePembayaran,
                        items: selectedItems,
                        orderId: newOrderId,
                        transactionTime: currentTime,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Konfirmasi Pesanan",
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
