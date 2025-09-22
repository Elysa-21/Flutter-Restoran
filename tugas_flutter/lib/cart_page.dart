import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/cart.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Cart cart = Cart();

  final Set<int> _selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
        backgroundColor: Colors.deepOrange,
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Keranjang masih kosong 🛒",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      final isSelected = _selectedIndexes.contains(index);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: isSelected,
                            activeColor: Colors.deepOrange,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedIndexes.add(index);
                                } else {
                                  _selectedIndexes.remove(index);
                                }
                              });
                            },
                          ),
                          title: Text(
                            cartItem.menu.nama,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "Rp ${cartItem.menu.harga} x ${cartItem.quantity} = Rp ${cartItem.totalPrice}",
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    cart.decreaseItem(cartItem.menu);
                                  });
                                },
                              ),
                              Text(
                                "${cartItem.quantity}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    cart.addItem(cartItem.menu);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Footer total + tombol checkout
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: const Border(
                      top: BorderSide(color: Colors.deepOrange, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: Rp ${_getSelectedTotal()}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _selectedIndexes.isEmpty
                            ? null
                            : () {
                                final selectedItems = _selectedIndexes
                                    .map((i) => cart.items[i])
                                    .toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                      items:
                                          selectedItems, 
                                    ),
                                  ),
                                );
                              },
                        child: const Text(
                          "Order",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  int _getSelectedTotal() {
    int total = 0;
    for (var i in _selectedIndexes) {
      total += cart.items[i].totalPrice;
    }
    return total;
  }
}
