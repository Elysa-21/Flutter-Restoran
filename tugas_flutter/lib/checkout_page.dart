import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_flutter/models/cart.dart';
import 'package:tugas_flutter/struk_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> items;
  const CheckoutPage({super.key, required this.items});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _namaController = TextEditingController();
  String _metodePembayaran = "Cash";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar item
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
                        "${item.quantity} x ${item.menu.hargaFormatted}",
                      ),
                      trailing: Text(
                        "Rp ${(item.menu.harga * item.quantity)}",
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
                      widget.items
                          .fold(0, (sum, item) => sum + item.totalPrice)
                          .toString(),
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

            //Input Nama
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: "Nama Pemesan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            //Pilih Metode Pembayaran
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

            //Konfirmasi
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
                  if (_namaController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nama pemesan harus diisi')),
                    );
                  } else {
                    final selectedItems = List<CartItem>.from(widget.items);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StrukPage(
                          nama: _namaController.text,
                          metode: _metodePembayaran,
                          items: selectedItems,
                        ),
                      ),
                    );
                  }
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
