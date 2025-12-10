import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Pastikan import ini sesuai dengan lokasi file EditProfilePage kamu
import 'package:weebsoul/screens/edit_profile_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // State untuk switch notifikasi
  bool isNewAnimeOn = true;
  bool isSubscribeOn = true;
  bool isReplyOn = true;

  // ⚡ Data user dari Supabase
  String userName = "Loading...";
  String userEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ⚡ Ambil data user dari Supabase Auth
  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          userEmail = user.email ?? "No Email";
          // Ambil username dari metadata, default ke "User" jika null
          userName = user.userMetadata?['username'] ?? "User";
        });
      }
    }
  }

  // ⚡ Fungsi Logout Terpisah untuk menghindari bug
  Future<void> _handleLogout() async {
    try {
      // 1. Tutup Dialog Konfirmasi terlebih dahulu
      Navigator.of(context).pop();

      // 2. Lakukan Logout Supabase
      await Supabase.instance.client.auth.signOut();

      // 3. Cek apakah widget masih aktif sebelum navigasi
      if (mounted) {
        // 4. Pindah ke halaman Login dan hapus semua history halaman sebelumnya
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      // Jika terjadi error (opsional: tampilkan snackbar)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal Logout: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Setting Aplikasi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= PROFIL SECTION =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://cdn.dribbble.com/userupload/17507007/file/original-d70a169a94153ac2b0f60a8cccb59651.png?resize=400x0",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info User
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= AKUN (Edit Profil) =================
            _buildSectionTitle("Akun"),
            _buildMenuTile(
              title: "Edit Profil",
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
                _loadUserData();
              },
            ),

            const SizedBox(height: 20),

            // ================= NOTIFIKASI =================
            _buildSectionTitle("Notifikasi"),
            _buildSwitchTile(
              title: "New Anime",
              value: isNewAnimeOn,
              onChanged: (val) => setState(() => isNewAnimeOn = val),
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              title: "Subscribe New Episode",
              value: isSubscribeOn,
              onChanged: (val) => setState(() => isSubscribeOn = val),
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              title: "Reply Comment",
              value: isReplyOn,
              onChanged: (val) => setState(() => isReplyOn = val),
            ),

            const SizedBox(height: 20),

            // ================= ABOUT =================
            _buildSectionTitle("About"),
            _buildInfoTile("Version", "1.1.5 (46)"),
            const SizedBox(height: 12),
            _buildInfoTile("Email Admin", "admin@weebsoul.app"),
            const SizedBox(height: 12),
            _buildInfoTile("Bantu Rating", "5 ⭐"),

            const SizedBox(height: 20),

            // ================= PRIVACY & TERMS =================
            Row(
              children: [
                Expanded(child: _buildSmallButton("Privacy Policy")),
                const SizedBox(width: 12),
                Expanded(child: _buildSmallButton("Terms of Service")),
              ],
            ),

            const SizedBox(height: 30),

            // ================= LOGOUT BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D4D), // Merah logout
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  // ⚡ TAMPILKAN POPUP KONFIRMASI
                  showDialog(
                    context: context,
                    // Barrier dismissible false agar user harus memilih opsi
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF2C2C2C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          "Konfirmasi Logout",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          "Apakah Anda yakin ingin keluar dari akun?",
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                        actions: [
                          // Tombol Batal
                          TextButton(
                            onPressed: () {
                              Navigator.of(
                                dialogContext,
                              ).pop(); // Tutup dialog saja
                            },
                            child: Text(
                              "Batal",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Tombol Logout (Panggil fungsi _handleLogout)
                          TextButton(
                            onPressed: _handleLogout,
                            child: Text(
                              "Logout",
                              style: GoogleFonts.poppins(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "Logout",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Judul Section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // WIDGET HELPER: Menu Biasa
  Widget _buildMenuTile({
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Switch Tile
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
            activeTrackColor: Colors.blueAccent.withOpacity(0.4),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER: Info Text
  Widget _buildInfoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: value.contains("⭐")
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER: Tombol Kecil
  Widget _buildSmallButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
        ),
      ),
    );
  }
}
