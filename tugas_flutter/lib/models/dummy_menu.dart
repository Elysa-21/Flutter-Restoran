import 'menu.dart';
import 'makanan.dart';
import 'minuman.dart';
import 'camilan.dart';

final List<Menu> dummyMenu = [
  Makanan(
    nama: "Nasi Goreng",
    gambar: "assets/makanan/nasigoreng.png",
    harga: 15000,
    deskripsi:
        "Nasi goreng kampung dengan bumbu rempah khas Dapur Mama dengan campuran telur dan ayam",
    sambal: true,
  ),
  Makanan(
    nama: "Ayam Geprek",
    gambar: "assets/makanan/ayamgeprek.png",
    harga: 18000,
    deskripsi:
        "Ayam goreng crispy disajikan dengan sambal ulek pedas khas Dapur Mama.",
    sambal: true,
  ),
  Makanan(
    nama: "Rawon",
    gambar: "assets/makanan/rawon.png",
    harga: 25000,
    deskripsi: "Rawon daging sapi dengan kuah hitam dan daging yang empuk",
    sambal: true,
  ),
  Makanan(
    nama: "Nasi Kuning",
    gambar: "assets/makanan/nasikuning.png",
    harga: 20000,
    deskripsi:
        "Nasi kuning gurih lengkap dengan lauk ayam, telur, tempe, bakwan jagung.",
    sambal: true,
  ),
  Makanan(
    nama: "Ayam Goreng Spesial",
    gambar: "assets/makanan/ayamgoreng.png",
    harga: 22000,
    deskripsi: "Ayam goreng bumbu rumah, renyah di luar, empuk di dalam.",
    sambal: true,
  ),
  Makanan(
    nama: "Ikan Goreng",
    gambar: "assets/makanan/ikangoreng.png",
    harga: 24000,
    deskripsi: "Ikan Nila goreng crispy dengan rasa khas.",
    sambal: true,
  ),
  Makanan(
    nama: "Nasi Liwet",
    gambar: "assets/makanan/nasiliwet.png",
    harga: 20000,
    deskripsi: "Nasi liwet wangi santan, lauk pelengkap khas Sunda.",
    sambal: true,
  ),
  Makanan(
    nama: "Ayam Sambal Ijo",
    gambar: "assets/makanan/ayamsambalijo.png",
    harga: 23000,
    deskripsi: "Ayam disajikan dengan sambal ijo segar yang nikmat.",
    sambal: true,
  ),
  Makanan(
    nama: "Soto Ayam",
    gambar: "assets/makanan/sotoayam.png",
    harga: 18000,
    deskripsi: "Soto ayam hangat dengan suwiran ayam dan telur.",
    sambal: true,
  ),
  Makanan(
    nama: "Pecel Lele",
    gambar: "assets/makanan/pecellele.png",
    harga: 17000,
    deskripsi: "Lele goreng dengan sambal pedas dan lalapan.",
    sambal: true,
  ),

  Minuman(
    nama: "Es Teh",
    gambar: "assets/minuman/esteh.png",
    harga: 5000,
    deskripsi: "Es teh manis segar untuk melepas dahaga.",
    dingin: true,
  ),
  Minuman(
    nama: "Es Jeruk",
    gambar: "assets/minuman/esjeruk.png",
    harga: 7000,
    deskripsi: "Perasan jeruk segar dengan es dan sedikit gula.",
    dingin: true,
  ),
  Minuman(
    nama: "Es Dawet",
    gambar: "assets/minuman/esdawet.png",
    harga: 10000,
    deskripsi: "Dawet cendol dengan santan manis.",
    dingin: true,
  ),
  Minuman(
    nama: "Es Degan",
    gambar: "assets/minuman/esdegan.png",
    harga: 12000,
    deskripsi: "Kelapa muda dicampur es batu, siap melepas dahaga.",
    dingin: true,
  ),
  Minuman(
    nama: "Es Kuwut",
    gambar: "assets/minuman/eskuwut.png",
    harga: 12000,
    deskripsi: "Minuman segar khas dengan parutan mentimun yang segar.",
    dingin: true,
  ),
  Minuman(
    nama: "Wedang Jahe",
    gambar: "assets/minuman/wedangjahe.png",
    harga: 10000,
    deskripsi: "Minuman manis dengan rasa jahe, siap menghangatkanmu",
    dingin: false,
  ),
  Minuman(
    nama: "Wedang Ronde",
    gambar: "assets/minuman/wedangronde.png",
    harga: 10000,
    deskripsi:
        "Minuman manis berbahan dasar santan dengan topping roti serta kacang.",
    dingin: false,
  ),

  Camilan(
    nama: "Bakwan Jagung",
    gambar: "assets/camilan/bakwanjagung.png",
    harga: 6000,
    deskripsi: "Bakwan jagung gurih renyah.",
    gorengan: true,
  ),
  Camilan(
    nama: "Pisang Goreng",
    gambar: "assets/camilan/pisanggoreng.png",
    harga: 8000,
    deskripsi: "Pisang goreng manis dan renyah.",
    gorengan: true,
  ),
  Camilan(
    nama: "Tempe Mendoan",
    gambar: "assets/camilan/tempemendoan.png",
    harga: 6000,
    deskripsi: "Tempe tipis mendoan harum dan gurih.",
    gorengan: true,
  ),
  Camilan(
    nama: "Cireng Ayam",
    gambar: "assets/camilan/cirengayam.png",
    harga: 7000,
    deskripsi: "Cireng isi ayam pedas gurih.",
    gorengan: true,
  ),
  Camilan(
    nama: "Tahu Isi",
    gambar: "assets/camilan/tahuisi.png",
    harga: 6000,
    deskripsi: "Tahu goreng dengan isian sayur dan daging cincang.",
    gorengan: true,
  ),
  Camilan(
    nama: "Dimsum",
    gambar: "assets/camilan/dimsum.png",
    harga: 15000,
    deskripsi: "Dimsum daging ayam dengan saos yang khas.",
    gorengan: false,
  ),
  Camilan(
    nama: "Kue Putu",
    gambar: "assets/camilan/kueputu.png",
    harga: 10000,
    deskripsi:
        "Kue Putu yang manis ditaburi dengan parutan kelapa, disajikan hangat.",
    gorengan: false,
  ),
];
