import 'menu.dart';

class CartItem {
  final Menu menu;
  int quantity;

  CartItem({required this.menu, this.quantity = 1});

  int get totalPrice => menu.harga * quantity;
}

class Cart {
  static final Cart _instance = Cart._internal();
  factory Cart() => _instance;
  Cart._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Tambah item ke keranjang
  void addItem(Menu menu) {
    final index = _items.indexWhere((item) => item.menu.nama == menu.nama);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(menu: menu));
    }
  }

  // Kurangi jumlah item 
  void decreaseItem(Menu menu) {
    final index = _items.indexWhere((item) => item.menu.nama == menu.nama);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  // Hapus item langsung dari keranjang
  void removeItem(Menu menu) {
    _items.removeWhere((item) => item.menu.nama == menu.nama);
  }

  // Kosongkan keranjang
  void clear() => _items.clear();

  // Total jumlah semua barang
  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  // Total harga semua barang
  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);
}
