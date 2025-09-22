import 'menu.dart';

class Camilan extends Menu {
  bool _gorengan;

  Camilan({
    required String nama,
    required String gambar,
    int harga = 0,
    String deskripsi = '',
    bool gorengan = true,
  })  : _gorengan = gorengan,
        super(nama: nama, kategori: 'Camilan', gambar: gambar, harga: harga, deskripsi: deskripsi);

  bool get gorengan => _gorengan;
  set gorengan(bool v) => _gorengan = v;

  @override
  String deskripsi() {
    final base = super.deskripsi();
    return _gorengan ? '$base\nTipe : gorengan.' : '$base\nTipe : non-gorengan.';
  }
}
