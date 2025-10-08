import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/cart.dart';
import 'checkout_page.dart';
import 'package:intl/intl.dart';
import 'models/order.dart';

class CartPage extends StatefulWidget {
  final List<Order> orders;
  final void Function(Order) onOrderAdded; // Callback to add order

  const CartPage({
    super.key,
    required this.orders,
    required this.onOrderAdded,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Cart cart = Cart();
  final Set<int> _selectedIndexes = {};

  String _formatRupiah(int total) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(total)}';
  }

  String _getSelectedTotalFormatted() {
    int total = 0;
    for (var i in _selectedIndexes) {
      if (i < cart.items.length) total += cart.items[i].totalPrice;
    }
    return _formatRupiah(total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
        backgroundColor: Colors.deepOrange,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text("Keranjang masih kosong 🛒"))
          : ListView.builder(
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
                          if (val == true)
                            _selectedIndexes.add(index);
                          else
                            _selectedIndexes.remove(index);
                        });
                      },
                    ),
                    title: Text(
                      cartItem.menu.nama,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${cartItem.menu.harga} x ${cartItem.quantity} = ${cartItem.totalPrice}',
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
                              if (cartItem.quantity == 0)
                                _selectedIndexes.remove(index);
                            });
                          },
                        ),
                        Text("${cartItem.quantity}"),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () =>
                              setState(() => cart.addItem(cartItem.menu)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Container(
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
                      "Total: ${_getSelectedTotalFormatted()}",
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
                        items: selectedItems,
                        onOrderAdded: widget.onOrderAdded,
                      ),
                                ),
                              );
                            },
                      child: const Text(
                        "Order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
