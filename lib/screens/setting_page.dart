import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                color: const Color(0xFF1E1E1E), // Match background
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
                        ), // Ganti dengan aset lokal jika ada
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info User (Tanpa Level)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "24-056 M Rizky P Lubis",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "lubisr002@gmail.com",
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

            // Di dalam Column -> children
            // ================= AKUN (Edit Profil) =================
            _buildSectionTitle("Akun"),
            _buildMenuTile(
              title: "Edit Profil",
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
              onTap: () {
                // Navigasi ke EditProfilePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
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

            // ================= LOGOUT =================
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
                  // Tambahkan logika logout di sini
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

  // WIDGET HELPER: Menu Biasa (Container Rounded)
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
          color: const Color(0xFF2C2C2C), // Warna card abu gelap
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

  // WIDGET HELPER: Info Text (Kanan Kiri)
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

  // WIDGET HELPER: Tombol Kecil (Privacy/Terms)
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
