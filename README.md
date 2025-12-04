# 🎬 Weebsoul - Anime Streaming App

Aplikasi streaming anime berbasis Flutter dengan fitur komentar dan favorit yang terintegrasi dengan Supabase.

---

## � Tentang Aplikasi

**Weebsoul** adalah aplikasi mobile untuk menonton anime dengan fitur-fitur modern seperti sistem komentar real-time, daftar favorit personal, dan jadwal tayang anime berdasarkan hari.

### ✨ Fitur Utama

#### 🔐 User Authentication
- **Register** - Daftar akun baru dengan email & password
- **Login** - Masuk ke akun Anda
- **Profile** - Kelola profil user (nama, bio, foto)

#### 🎥 Streaming & Video Player
- **Watch Anime** - Streaming anime langsung dari cloud storage
- **Episode Management** - Pilih episode yang ingin ditonton
- **Video Controls** - Play, pause, seek, fullscreen
- **Auto Quality** - Streaming adaptif sesuai koneksi

#### 💬 Sistem Komentar
- **Komentar per Episode** - Diskusi untuk setiap episode
- **Real-time Comments** - Komentar muncul langsung
- **User Identity** - Setiap komentar menampilkan nama & avatar user
- **Timestamp** - Waktu relatif komentar (2 jam lalu, 1 hari lalu)

#### ❤️ Sistem Favorit
- **Add to Favorites** - Simpan anime favorit Anda
- **Personal Collection** - Setiap user punya daftar favorit sendiri
- **Quick Access** - Akses cepat ke anime favorit dari halaman Favorit
- **Toggle Favorite** - Tambah/hapus favorit dengan satu klik

#### 📅 Jadwal Tayang
- **Schedule by Day** - Lihat anime yang tayang per hari (Minggu - Sabtu)
- **Browse by Genre** - Filter anime berdasarkan genre
- **Anime Details** - Informasi lengkap (rating, deskripsi, genre)

---

## 📖 Cara Pakai Aplikasi (Sebagai User)

### 1️⃣ **Pertama Kali Membuka Aplikasi**

1. **Register Akun:**
   - Buka aplikasi
   - Klik "Register"
   - Isi email, password, nama
   - Klik "Register"

2. **Login:**
   - Masukkan email & password
   - Klik "Login"

### 2️⃣ **Menonton Anime**

1. **Pilih Anime:**
   - Browse dari halaman Home atau Schedule
   - Klik card anime yang ingin ditonton

2. **Pilih Episode:**
   - Di halaman detail, scroll ke bawah
   - Klik episode yang ingin ditonton

3. **Tonton:**
   - Video player akan terbuka
   - Gunakan controls untuk play/pause/seek
   - Klik fullscreen untuk layar penuh

### 3️⃣ **Menambah Favorit**

1. **Buka Detail Anime:**
   - Klik anime yang ingin difavoritkan

2. **Klik Tombol Favorit:**
   - Klik "Add Favorite" (icon ❤️)
   - Tombol berubah jadi "Favorited" (merah)

3. **Lihat Favorit:**
   - Buka tab "Favorit" di bottom navigation
   - Semua anime favorit Anda ada di sini

### 4️⃣ **Berkomentar**

1. **Buka Video Player:**
   - Pilih episode yang ingin ditonton

2. **Scroll ke Bagian Komentar:**
   - Di bawah video player ada section "Komentar"

3. **Tulis Komentar:**
   - Ketik komentar di input field
   - Klik icon send (✈️) atau tekan Enter
   - Komentar langsung muncul!

---

## 💻 Setup untuk Developer

### Prerequisites
- Flutter SDK (3.9.2+)
- Git
- Android Studio / VS Code
- Akses Supabase credentials

### Quick Start

```bash
# 1. Clone repository
git clone https://github.com/IlmanZuhry/weebsoul--app.git
cd weebsoul

# 2. Install dependencies
flutter pub get

# 3. Buat file .env di root project
# Isi dengan:
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# 4. Run aplikasi
flutter run
```

### Setup Database (Untuk Developer)

Jalankan SQL scripts berikut di Supabase SQL Editor:

1. `supabase_setup.sql` - Setup videos table
2. `comments_setup.sql` - Setup comments table
3. `favorites_setup.sql` - Setup favorites table
4. `update_favorites_table.sql` - Update favorites dengan data lengkap

### Struktur Project

```
lib/
├── data/           # Data anime statis
├── models/         # Data models
├── screens/        # UI screens
├── services/       # Backend services
└── main.dart       # Entry point
```

---

## 🔐 Environment Variables

File `.env` **TIDAK** ada di GitHub untuk keamanan.

**Untuk menjalankan aplikasi:**
1. Buat file `.env` di root project
2. Isi dengan Supabase credentials
3. Lihat `.env.example` untuk template

---

## 🛠️ Tech Stack

- **Frontend:** Flutter & Dart
- **Backend:** Supabase (Database + Auth + Storage)
- **Video Player:** Chewie + Video Player
- **State Management:** StatefulWidget
- **Environment:** flutter_dotenv

---

## � Screenshots

> *Coming soon - tambahkan screenshot aplikasi di sini*

---

## 👥 Tim Developer

- **Ilman Zuhry** - Full Stack Developer

---

## 📝 License

Private project - Educational purposes only.

---

## 🆘 Troubleshooting

**Q: Aplikasi crash saat startup?**  
A: Pastikan file `.env` sudah dibuat dan diisi dengan credentials yang benar.

**Q: Video tidak bisa diputar?**  
A: Pastikan URL video sudah ada di Supabase Storage dan database.

**Q: Komentar tidak muncul?**  
A: Pastikan sudah login dan table `comments` sudah dibuat di Supabase.

**Q: Favorit tidak tersimpan?**  
A: Pastikan table `favorites` sudah dibuat dan RLS policies sudah aktif.

---

**Happy Coding! 🚀**
