import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_flutter/order_history_page.dart';
import 'package:tugas_flutter/user_data_page.dart';
import 'package:tugas_flutter/device_info_page.dart';
import 'package:tugas_flutter/welcome_page.dart';
import 'package:tugas_flutter/models/order.dart';
import 'package:getwidget/getwidget.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final List<Order> orders;

  const ProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.orders,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String username;
  late String email;
  String noHp = "";

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        username = prefs.getString("nama") ?? widget.username;
        noHp = prefs.getString("noHp") ?? "";
      });
    } catch (e) {
      print("Error loading SharedPreferences: $e");
    }
  }

  Future<void> _navigateToUserData(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserDataPage(username: username, email: email, noHp: noHp),
      ),
    );

    if (result == true) {
      _loadUserData();
    }
  }

  void _handleLogout() async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog

                final prefs = await SharedPreferences.getInstance();

                await prefs.remove("nama");
                await prefs.remove("email");
                await prefs.remove("noHp");

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Anda telah berhasil Logout!'),
                    duration: Duration(seconds: 1),
                  ),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Akun Saya",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 26),
            color: Colors.white,
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          // --- 1. Header Profil (Menggunakan GFAvatar) ---
          Card(
            color: Colors.deepOrange.shade50,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.only(bottom: 25),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // MENGGUNAKAN GFAvatar
                  GFAvatar(
                    size: GFSize.LARGE,
                    backgroundColor: Colors.deepOrange,
                    shape: GFAvatarShape.circle,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade800,
                        ),
                      ),
                      Text(
                        "Selamat Datang di Dapur Mama",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- 2. Fitur Device Info (MENGGUNAKAN GFCARD) ---
          _buildFeatureTile(
            context,
            icon: Icons.devices_outlined,
            title: "Device Info",
            subtitle: "Model dan OS",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeviceInfoPage()),
              );
            },
          ),

          // --- 3. Fitur Data Pengguna (MENGGUNAKAN GFCARD) ---
          _buildFeatureTile(
            context,
            icon: Icons.account_circle_outlined,
            title: "Data Pengguna",
            subtitle: "Nama, Email, No. HP",
            onTap: () => _navigateToUserData(context),
          ),

          // --- 4. Fitur Riwayat Pesanan ---
          _buildFeatureTile(
            context,
            icon: Icons.history_toggle_off,
            title: "Riwayat Pesanan",
            subtitle: "Lihat pesanan Anda sebelumnya dan beri ulasan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: GFCard(
        elevation: 4,
        content: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 0,
          ),
          leading: Icon(icon, color: Colors.deepOrange, size: 32),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBadge)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GFBadge(
                    child: null,
                    color: GFColors.DANGER,
                    size: GFSize.SMALL,
                    shape: GFBadgeShape.circle,
                  ),
                ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
