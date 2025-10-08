import 'menu.dart';

class Minuman extends Menu {
  bool _dingin;

  Minuman({
    required String nama,
    required String gambar,
    int harga = 0,
    String deskripsi = '',
    bool dingin = true,
  }) : _dingin = dingin,
       super(
         nama: nama,
         kategori: 'Minuman',
         gambar: gambar,
         harga: harga,
         deskripsi: deskripsi,
       );

  bool get dingin => _dingin;
  set dingin(bool v) => _dingin = v;

  @override
  String deskripsi() {
    final base = super.deskripsi();
    return _dingin ? '$base\nDisajikan : dingin.' : '$base\nDisajikan : hangat.';
  }
}
