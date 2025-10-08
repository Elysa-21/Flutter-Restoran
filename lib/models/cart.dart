import 'menu.dart';
import 'package:intl/intl.dart';

class CartItem {
  final Menu menu;
  int quantity;

  CartItem({required this.menu, this.quantity = 1});

  // Total harga
  int get totalPrice => menu.harga * quantity;

  // Format harga per item
  String get itemPriceFormatted {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(menu.harga);
  }

  // Format total harga
  String get totalPriceFormatted {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(totalPrice);
  }

  // Serialize ke Map
  Map<String, dynamic> toMap() {
    return {'menu': menu.toMap(), 'quantity': quantity};
  }

  // Deserialize dari Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      menu: Menu.fromMap(Map<String, dynamic>.from(map['menu'])),
      quantity: map['quantity'] ?? 1,
    );
  }
}

class Cart {
  static final Cart _instance = Cart._internal();
  factory Cart() => _instance;
  Cart._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Menu menu) {
    final index = _items.indexWhere((i) => i.menu.nama == menu.nama);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(menu: menu));
    }
  }

  void decreaseItem(Menu menu) {
    final index = _items.indexWhere((i) => i.menu.nama == menu.nama);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  void removeItem(Menu menu) {
    _items.removeWhere((i) => i.menu.nama == menu.nama);
  }

  void clear() => _items.clear();

  int get totalPrice => _items.fold(0, (sum, i) => sum + i.totalPrice);
}
