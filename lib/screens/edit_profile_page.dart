import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller untuk menangani input text
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // ⚡ Inisialisasi dengan data kosong, akan diisi dari Supabase
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    
    _loadUserData();
  }

  // ⚡ Ambil data user dari Supabase
  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _nameController.text = user.userMetadata?['username'] ?? '';
        _emailController.text = user.email ?? '';
        // Ambil phone dan bio dari metadata jika ada
        _phoneController.text = user.userMetadata?['phone'] ?? '';
        _bioController.text = user.userMetadata?['bio'] ?? '';
      });
    }
  }

  // ⚡ Simpan perubahan profil ke Supabase
  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama tidak boleh kosong!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // ⚡ Update user metadata di Supabase Auth
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'username': name,
            'phone': phone,
            'bio': bio,
          },
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Kembali ke Setting page
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menyimpan profil, coba lagi."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Edit Profil",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // ================= FOTO PROFIL =================
            Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    image: const DecorationImage(
                      image: NetworkImage(
                          "https://cdn.dribbble.com/userupload/17507007/file/original-d70a169a94153ac2b0f60a8cccb59651.png?resize=400x0"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1E1E1E), width: 3),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ================= FORM INPUT =================
            _buildTextField(
              label: "Nama Lengkap",
              controller: _nameController,
              icon: Icons.person_outline,
              placeholder: "Masukkan nama lengkap",
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: "Email",
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              placeholder: "email@example.com",
              readOnly: true, // ⚡ Email tidak bisa diubah
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: "Nomor Telepon",
              controller: _phoneController,
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
              placeholder: "Contoh: 0812-3456-7890",
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: "Bio / Tentang Saya",
              controller: _bioController,
              icon: Icons.info_outline,
              maxLines: 3,
              placeholder: "Ceritakan tentang diri Anda...",
            ),
            
            const SizedBox(height: 40),

            // ================= TOMBOL SAVE =================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blueAccent.withOpacity(0.4),
                ),
                onPressed: _saveProfile, // ⚡ Panggil fungsi save
                child: Text(
                  "Simpan Perubahan",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: TEXT FIELD CUSTOM
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String placeholder = "",
    bool readOnly = false, // ⚡ Parameter untuk read-only
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: readOnly 
                ? const Color(0xFF1E1E1E) // Lebih gelap jika read-only
                : const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            readOnly: readOnly, // ⚡ Set read-only
            style: GoogleFonts.poppins(
              color: readOnly ? Colors.grey : Colors.white,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[500], size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}