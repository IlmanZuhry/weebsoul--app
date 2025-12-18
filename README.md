# 🎬 Weebsoul - Anime Streaming App

## 📱 Nama Aplikasi

Weebsoul - Anime Streaming App

## 👥 Tim Pengembang

- Ilman Zuhry Hartarto (241712047)
- M.Rizky Pramadhana (241712056)
- Andri Wiguna (241712062)
- Mahesa Penemuan Ali (241712064)
- Beprian Tulus (241712065)


## 📝 Deskripsi Singkat Aplikasi

Weebsoul adalah aplikasi streaming anime berbasis Flutter yang menyediakan pengalaman menonton anime yang seamless dan modern. Aplikasi ini dilengkapi dengan fitur-fitur seperti jadwal rilis anime, riwayat tontonan, favorit, komentar episode, sistem like, dan profil pengguna yang dapat dikustomisasi. Weebsoul menggunakan Supabase sebagai backend untuk autentikasi, database, dan storage.

## ✨ Daftar Fitur pada Aplikasi

- Login & Register dengan Supabase Auth
- Persistent Login (otomatis login saat buka aplikasi)
- Edit Profile (username, phone, bio, foto profil)
- Video Player dengan kontrol lengkap
- Jadwal rilis anime berdasarkan hari
- Ongoing Anime dan Subscribed Anime
- Detail Anime lengkap (sinopsis, rating, genre)
- Riwayat Tontonan dengan progress tracking
- Favorit Dinamis (tambah/hapus anime favorit)
- Komentar Episode
- Like System pada video
- Splash Screen

## 🛠️ Stack Technology yang Digunakan

- Flutter SDK ^3.9.2
- Dart ^3.9.2
- Supabase ^2.10.3

## 📦 Library / Framework yang Digunakan

- flutter (SDK)
- google_fonts ^6.1.0
- chewie ^1.7.0
- video_player ^2.10.1
- cupertino_icons ^1.0.8
- supabase_flutter ^2.10.3
- flutter_dotenv ^6.0.0
- flutter_launcher_icons ^0.13.1
- flutter_native_splash ^2.3.10
- flutter_lints ^5.0.0

## 🔌 Public / Private API yang Digunakan

Aplikasi ini menggunakan Supabase sebagai backend dengan fitur:
- Supabase Auth (Email/Password Authentication)
- Supabase Database (PostgreSQL)
- Supabase Storage (untuk foto vidio)

Environment Variables yang digunakan:
- SUPABASE_URL
- SUPABASE_ANON_KEY


## 🚀 Cara Menjalankan Aplikasi

### 📋 Prerequisites
- Flutter SDK (versi 3.9.2 atau lebih tinggi)
- Dart SDK (versi 3.9.2 atau lebih tinggi)
- Android Studio / VS Code dengan Flutter extension
- Git

---

## 👨‍💻 Untuk Developer (Setup Lengkap)

Ikuti langkah-langkah ini jika Anda ingin setup Supabase sendiri dan develop aplikasi ini.

### 1. Clone Repository
```bash
git clone https://github.com/IlmanZuhry/weebsoul--app.git
cd weebsoul
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Supabase Project Baru
1. Buat akun di https://supabase.com
2. Buat project baru di Supabase Dashboard
3. Catat SUPABASE_URL dan SUPABASE_ANON_KEY dari Settings → API

### 4. Setup Environment Variables
Buat file `.env` di root project:
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

**PENTING:** File `.env` sudah ada di `.gitignore`, jangan commit file ini!

### 5. Setup Database
Jalankan SQL berikut di Supabase SQL Editor untuk membuat tabel yang diperlukan:
- Buka Supabase Dashboard → SQL Editor
- Copy paste SQL schema dari developer documentation
- Atau hubungi developer untuk mendapatkan SQL schema lengkap

### 6. Setup Storage
1. Buka Supabase Dashboard → Storage
2. Buat bucket baru dengan nama `vidio`
3. Set bucket menjadi Public
4. Tambahkan policy untuk authenticated users

### 7. Run Aplikasi
```bash
# Cek device yang tersedia
flutter devices

# Run di device yang terhubung
flutter run

# Run di device tertentu
flutter run -d <device_id>
```

---

## 👤 Untuk User (Menggunakan Server yang Sama)

Ikuti langkah-langkah ini jika Anda ingin menjalankan aplikasi menggunakan server Supabase yang sudah ada.

### 1. Clone Repository
```bash
git clone https://github.com/IlmanZuhry/weebsoul--app.git
cd weebsoul
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Minta File .env dari Developer
Hubungi developer (Ilman Zuhry) untuk mendapatkan file `.env` yang berisi kredensial Supabase.

Setelah mendapatkan file `.env`, letakkan di root project (folder `weebsoul/`).

**Struktur file .env:**
```
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=xxxxx
```

### 4. Run Aplikasi
```bash
# Cek device yang tersedia
flutter devices

# Run di device yang terhubung
flutter run
```

**Catatan:** Dengan menggunakan file `.env` yang sama, Anda akan terhubung ke database yang sama dengan developer, sehingga data seperti akun, favorit, dan riwayat akan tersinkronisasi.

---

## 🐛 Troubleshooting

### Error: "Error loading .env file"
- Pastikan file `.env` ada di root project (folder `weebsoul/`)
- Pastikan format `.env` benar (tidak ada spasi di sekitar tanda `=`)
- Contoh yang benar: `SUPABASE_URL=https://xxx.supabase.co`
- Contoh yang salah: `SUPABASE_URL = https://xxx.supabase.co`

### Error: "Supabase connection error"
- Cek apakah `SUPABASE_URL` dan `SUPABASE_ANON_KEY` sudah benar
- Pastikan tidak ada trailing slash di `SUPABASE_URL`
- Pastikan koneksi internet aktif

### Error: "Video tidak bisa diputar"
- Pastikan tabel `videos` sudah dibuat di database
- Pastikan `video_url` valid dan bisa diakses
- Cek koneksi internet

### Error: "Flutter SDK not found"
- Pastikan Flutter SDK sudah terinstall
- Jalankan `flutter doctor` untuk cek instalasi
- Tambahkan Flutter ke PATH environment variable

---
