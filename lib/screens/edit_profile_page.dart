import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _nameController.text = user.userMetadata?['username'] ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.userMetadata?['phone'] ?? '';
        _bioController.text = user.userMetadata?['bio'] ?? '';
      });
    }
  }

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
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'username': name, 'phone': phone, 'bio': bio}),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menyimpan profil."),
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
                        "https://cdn.dribbble.com/userupload/17507007/file/original-d70a169a94153ac2b0f60a8cccb59651.png?resize=400x0",
                      ),
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
                      border: Border.all(
                        color: const Color(0xFF1E1E1E),
                        width: 3,
                      ),
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

            // ================= FORM INPUT PROFIL =================
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
              readOnly: true,
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

            const SizedBox(height: 30),

            // ================= KEAMANAN =================
            const Divider(color: Colors.grey, thickness: 0.5),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Keamanan Akun",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // TOMBOL UBAH PASSWORD
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  _showChangePasswordDialog(context);
                },
                icon: const Icon(Icons.lock_reset),
                label: const Text("Ubah Kata Sandi"),
              ),
            ),

            const SizedBox(height: 40),

            // ================= TOMBOL SAVE PROFIL =================
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
                onPressed: _saveProfile,
                child: Text(
                  "Simpan Profil",
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

  // =======================================================
  // ⭐ DIALOG: UBAH PASSWORD (STANDARD)
  // =======================================================
  void _showChangePasswordDialog(BuildContext context) {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Ubah Kata Sandi",
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const Text(
                      "Masukkan kata sandi saat ini.",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),

                    // Input Password Lama
                    TextField(
                      controller: oldPassController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Kata Sandi Lama",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // Link Lupa Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog ubah pass
                          _showForgotPasswordDialog(context); // Buka dialog OTP
                        },
                        child: const Text(
                          "Lupa Kata Sandi?",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Input Password Baru
                    TextField(
                      controller: newPassController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Kata Sandi Baru",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          final oldPass = oldPassController.text.trim();
                          final newPass = newPassController.text.trim();
                          final email =
                              Supabase.instance.client.auth.currentUser?.email;

                          if (oldPass.isEmpty || newPass.isEmpty) {
                            setState(() {
                              isLoading = false;
                              errorMessage = "Semua kolom wajib diisi";
                            });
                            return;
                          }

                          try {
                            // Login ulang untuk verifikasi password lama
                            await Supabase.instance.client.auth
                                .signInWithPassword(
                                  email: email,
                                  password: oldPass,
                                );

                            // Update password
                            await Supabase.instance.client.auth.updateUser(
                              UserAttributes(password: newPass),
                            );

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("✅ Password berhasil diubah!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } on AuthException catch (e) {
                            setState(() {
                              isLoading = false;
                              errorMessage =
                                  "Password lama salah atau terjadi kesalahan.";
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              errorMessage = "Terjadi kesalahan sistem.";
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // =======================================================
  // ⭐ DIALOG: LUPA PASSWORD (OTP 6 ANGKA)
  // =======================================================
  void _showForgotPasswordDialog(BuildContext context) {
    final currentUserEmail =
        Supabase.instance.client.auth.currentUser?.email ?? "";
    final emailResetController = TextEditingController(text: currentUserEmail);
    final tokenController = TextEditingController();
    final newPasswordController = TextEditingController();

    int currentStep = 1;
    bool isLoading = false;
    String? statusMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                currentStep == 1 ? "Verifikasi Email" : "Reset Password",
                style: const TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (statusMessage != null) ...[
                      Text(
                        statusMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                    ],

                    if (currentStep == 1) ...[
                      const Text(
                        "Kode konfirmasi angka akan dikirim ke email.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailResetController,
                        style: const TextStyle(color: Colors.white),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        "Masukkan 6 angka kode unik dari email & password baru.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),

                      // ⚡ INPUT TOKEN (ANGKA SAJA)
                      TextField(
                        controller: tokenController,
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 8,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: "Kode 6 Angka",
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[900],
                          counterText: "",
                          hintText: "000000",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // INPUT PASSWORD BARU
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Password Baru",
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            statusMessage = null;
                          });

                          try {
                            final email = emailResetController.text.trim();

                            if (currentStep == 1) {
                              await Supabase.instance.client.auth
                                  .resetPasswordForEmail(email);
                              setState(() {
                                currentStep = 2;
                                isLoading = false;
                              });
                            } else {
                              final token = tokenController.text.trim();
                              final newPass = newPasswordController.text.trim();

                              if (token.length != 6)
                                throw "Kode harus 6 angka.";
                              if (newPass.isEmpty)
                                throw "Password baru wajib diisi.";

                              final res = await Supabase.instance.client.auth
                                  .verifyOTP(
                                    email: email,
                                    token: token,
                                    type: OtpType.recovery,
                                  );

                              if (res.session != null) {
                                await Supabase.instance.client.auth.updateUser(
                                  UserAttributes(password: newPass),
                                );

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "✅ Password berhasil direset!",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            }
                          } on AuthException catch (e) {
                            setState(() {
                              isLoading = false;
                              statusMessage = e.message;
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              statusMessage = "Terjadi kesalahan.";
                            });
                          }
                        },
                  child: Text(
                    currentStep == 1 ? "Kirim Kode" : "Reset Password",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String placeholder = "",
    bool readOnly = false,
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
            color: readOnly ? const Color(0xFF1E1E1E) : const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(16),
            border: readOnly ? Border.all(color: Colors.grey[800]!) : null,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            readOnly: readOnly,
            style: GoogleFonts.poppins(
              color: readOnly ? Colors.grey : Colors.white,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[500], size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
