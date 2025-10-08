import 'package:intl/intl.dart';

class Menu {
  String _nama;
  String _kategori;
  String _gambar;
  int _harga;
  String _deskripsi;

  Menu({
    required String nama,
    required String kategori,
    required String gambar,
    int harga = 0,
    String deskripsi = '',
  }) : _nama = nama,
       _kategori = kategori,
       _gambar = gambar,
       _harga = harga,
       _deskripsi = deskripsi;

  // ===== GETTERS =====
  String get nama => _nama;
  String get kategori => _kategori;
  String get gambar => _gambar;
  int get harga => _harga;
  String get deskripsiText => _deskripsi;

  // ===== SETTERS =====
  set nama(String v) => _nama = v;
  set kategori(String v) => _kategori = v;
  set gambar(String v) => _gambar = v;
  set harga(int v) => _harga = v;
  set deskripsiText(String v) => _deskripsi = v;

  String get hargaFormatted {
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedPrice = formatter.format(_harga);
    return 'Rp $formattedPrice';
  }

  String deskripsi() {
    if (_deskripsi.isNotEmpty) return _deskripsi;
    return '$_nama adalah menu kategori $_kategori.';
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': _nama,
      'kategori': _kategori,
      'gambar': _gambar,
      'harga': _harga,
      'deskripsi': _deskripsi,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> m) {
    return Menu(
      nama: m['nama'] ?? '',
      kategori: m['kategori'] ?? '',
      gambar: m['gambar'] ?? '',
      harga: m['harga'] ?? 0,
      deskripsi: m['deskripsi'] ?? '',
    );
  }
}
