import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_flutter/detail_menu_page.dart';
import 'package:tugas_flutter/models/menu.dart';
import 'package:tugas_flutter/models/dummy_menu.dart';
import 'package:badges/badges.dart' as badges;
import 'package:tugas_flutter/cart_page.dart';
import 'package:tugas_flutter/models/cart.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "Semua";
  String searchQuery = "";
  String sortOption = "default";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Filter kategori + search
    List<Menu> filteredMenu = dummyMenu.where((item) {
      final cocokKategori =
          selectedCategory == "Semua" || item.kategori == selectedCategory;
      final cocokSearch = item.nama.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return cocokKategori && cocokSearch;
    }).toList();

    //Sorting
    if (sortOption == "az") {
      filteredMenu.sort((a, b) => a.nama.compareTo(b.nama));
    } else if (sortOption == "za") {
      filteredMenu.sort((a, b) => b.nama.compareTo(a.nama));
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_pattern.png"),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(135, 252, 163, 85),
                  Color.fromARGB(142, 250, 188, 133),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Cari menu...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Header
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
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    239,
                                    234,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Selamat Datang, ${widget.username} 👋",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    220,
                                    180,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Nikmati setiap suapan kelezatan yang mengingatkanmu pada masakan Ibu di Dapur Mama...",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    200,
                                    150,
                                  ),
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

                  // Filter Chips
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
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
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

                  //Sorting Dropdown
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
                          border: Border.all(
                            color: Colors.deepOrange,
                            width: 1,
                          ),
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

                  //List Menu
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredMenu.length,
                    itemBuilder: (context, index) {
                      final item = filteredMenu[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
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
                                builder: (context) =>
                                    DetailMenuPage(menu: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            ).then((_) {
              setState(() {});
            });
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -8, end: -12),
              badgeContent: Text(
                Cart().items.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
            label: "Keranjang",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
