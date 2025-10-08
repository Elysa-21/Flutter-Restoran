import 'menu.dart';

class Makanan extends Menu {
  bool _sambal;

  Makanan({
    required String nama,
    required String gambar,
    int harga = 0,
    String deskripsi = '',
    bool sambal = false,
  })  : _sambal = sambal,
        super(nama: nama, kategori: 'Makanan', gambar: gambar, harga: harga, deskripsi: deskripsi);

  // getter / setter 
  bool get sambal => _sambal;
  set pedas(bool v) => _sambal = v;

  @override
  String deskripsi() {
    final base = super.deskripsi();
    
    return _sambal ? '$base\n** Free Sambal' : base;
  }
}
