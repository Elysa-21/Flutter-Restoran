import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_flutter/detail_menu_page.dart';
import 'package:tugas_flutter/models/menu.dart';
import 'package:tugas_flutter/models/dummy_menu.dart';
import 'package:badges/badges.dart' as badges;
import 'package:tugas_flutter/cart_page.dart';
import 'package:tugas_flutter/models/cart.dart';
import 'package:tugas_flutter/profil_page.dart';
import 'package:tugas_flutter/models/order.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String email;
  const HomePage({super.key, required this.username, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "Semua";
  String searchQuery = "";
  String sortOption = "default";
  final TextEditingController _searchController = TextEditingController();
  final List<Order> _orders = [];

  int _currentIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void _addOrder(Order order) {
    setState(() {
      _orders.add(order);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      CartPage(onOrderAdded: _addOrder, orders: _orders),
      ProfilePage(
        username: widget.username,
        email: widget.email,
        orders: _orders,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          const Icon(Icons.home, size: 30, color: Colors.white),
          badges.Badge(
            badgeContent: Text(
              Cart().items.length.toString(),
              style: const TextStyle(
                color: Colors.deepOrange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.white,
              padding: EdgeInsets.all(5),
            ),
            child: const Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.white,
            ),
          ),
          const Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: Colors.deepOrange,
        buttonBackgroundColor: Colors.deepOrange.shade600,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _buildHomeContent() {
    List<Menu> filteredMenu = dummyMenu.where((item) {
      final cocokKategori =
          selectedCategory == "Semua" || item.kategori == selectedCategory;
      final cocokSearch = item.nama.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return cocokKategori && cocokSearch;
    }).toList();

    if (sortOption == "az") {
      filteredMenu.sort((a, b) => a.nama.compareTo(b.nama));
    } else if (sortOption == "za") {
      filteredMenu.sort((a, b) => b.nama.compareTo(a.nama));
    }

    return Container(
      color: Colors.white, // background putih polos
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari menu...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.deepOrange,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  // efek bayangan biar ga “nempel”
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
              ),

              // Header (JANGAN DIUBAH)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 110, 42, 0),
                      Color.fromARGB(255, 255, 140, 60),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png", height: 160),
                    const SizedBox(width: 19),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dapur Mama",
                            style: GoogleFonts.berkshireSwash(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 239, 234),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Selamat Datang, ${widget.username} 👋",
                            style: GoogleFonts.aBeeZee(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 255, 220, 180),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Nikmati setiap suapan kelezatan yang mengingatkanmu pada masakan Ibu di Dapur Mama...",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 255, 200, 150),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Filter kategori
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["Semua", "Makanan", "Minuman", "Camilan"].map((
                    kategori,
                  ) {
                    bool isSelected = selectedCategory == kategori;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(
                          kategori,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                        pressElevation: 4,
                        selected: isSelected,
                        selectedColor: Colors.deepOrange,
                        backgroundColor: Colors.grey[200],
                        onSelected: (val) {
                          setState(() {
                            selectedCategory = kategori;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Sorting dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepOrange, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: sortOption,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.deepOrange,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "default",
                          child: Text("Default"),
                        ),
                        DropdownMenuItem(value: "az", child: Text("A - Z")),
                        DropdownMenuItem(value: "za", child: Text("Z - A")),
                      ],
                      onChanged: (val) {
                        setState(() {
                          sortOption = val!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // List Menu dengan border warna
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMenu.length,
                itemBuilder: (context, index) {
                  final item = filteredMenu[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Colors.deepOrange, // border pinggir
                        width: 1.5,
                      ),
                    ),
                    elevation: 0, // biar fokus ke border aja
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item.gambar,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.fastfood,
                                size: 28,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      title: Text(
                        item.nama,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.brown[800],
                        ),
                      ),
                      subtitle: Text(
                        item.kategori,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.deepOrange,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailMenuPage(menu: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
