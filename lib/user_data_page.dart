import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataPage extends StatefulWidget {
  final String username;
  final String email;
  final String noHp;

  const UserDataPage({
    super.key,
    required this.username,
    required this.email,
    required this.noHp,
  });

  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  String _nama = "";
  String _noHp = "";
  bool _isEditing = false;

  late TextEditingController _namaController;
  late TextEditingController _noHpController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nama = widget.username;
    _noHp = widget.noHp;
    _namaController = TextEditingController(text: _nama);
    _noHpController = TextEditingController(text: _noHp);
    _emailController = TextEditingController(text: widget.email);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString("nama") ?? widget.username;
      _noHp = prefs.getString("noHp") ?? "";
      final savedEmail = prefs.getString("email") ?? widget.email;
      _namaController.text = _nama;
      _noHpController.text = _noHp;
      _emailController.text = savedEmail;
    });
  }

  void _toggleEdit() async {
    if (_isEditing) {
      // Simpan perubahan
      setState(() {
        _nama = _namaController.text;
        _noHp = _noHpController.text;
        _isEditing = false;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("nama", _nama);
      await prefs.setString("noHp", _noHp);

      Navigator.pop(context, {"nama": _nama, "noHp": _noHp});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan!')));
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Field bisa diedit
  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          fillColor: enabled ? Colors.white : Colors.grey[100],
          filled: true,
        ),
      ),
    );
  }

  // Field tidak bisa diedit (Email)
  Widget _buildNonEditableField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          fillColor: Colors.grey[100],
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pengguna"),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informasi Akun",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 15),

            // Nama
            _buildEditableField(
              label: "Nama",
              controller: _namaController,
              enabled: _isEditing,
            ),

            // No HP
            _buildEditableField(
              label: "Nomor HP",
              controller: _noHpController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),

            // Email (tidak bisa diedit)
            _buildNonEditableField(
              label: "Email",
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            // Tombol Edit/Simpan
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: _toggleEdit,
                    icon: Icon(
                      _isEditing ? Icons.save : Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      _isEditing ? "SIMPAN" : "UBAH",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isEditing
                          ? Colors.green
                          : Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
