import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weebsoul/screens/splash_page.dart';

void main() {
  runApp(const WeebsoulApp());
}

class WeebsoulApp extends StatelessWidget {
  const WeebsoulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weebsoul',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
            height: 1.6,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      // PERBAIKAN DI SINI:
      // Mengarahkan ke SplashPage terlebih dahulu, bukan NavigationRoot
      home: const SplashPage(),
    );
  }
}

// ==========================================
//  MODEL DATA & DUMMY DATA
// ==========================================

class AnimeInfo {
  final String title;
  final String imageUrl;
  final double rating;
  final String episode;
  final bool isNew;
  final String views;
  final String duration;

  AnimeInfo({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.episode,
    this.isNew = false,
    required this.views,
    required this.duration,
  });
}

// --- CONTOH DATA DUMMY ---

// Data MINGGU
final List<AnimeInfo> mingguAnime = List.generate(
  6,
  (index) => AnimeInfo(
    title: "One Piece",
    imageUrl: "https://cdn.myanimelist.net/images/anime/6/73245.jpg",
    rating: 4.9,
    episode: "Eps ${1090 + index}",
    isNew: index == 0,
    views: "1.2M",
    duration: "24m",
  ),
);

// Data SENIN
final List<AnimeInfo> seninAnime = [
  AnimeInfo(
    title: "Bleach: TYBW",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1764/126627.jpg",
    rating: 4.8,
    episode: "Eps 24",
    isNew: true,
    views: "850k",
    duration: "24m",
  ),
  AnimeInfo(
    title: "Vinland Saga S2",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1170/124312.jpg",
    rating: 4.7,
    episode: "Eps 12",
    views: "500k",
    duration: "24m",
  ),
];

// Data SELASA
final List<AnimeInfo> selasaAnime = List.generate(
  4,
  (index) => AnimeInfo(
    title: "Chainsaw Man (Re-run)",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1806/126216.jpg",
    rating: 4.8,
    episode: "Eps ${index + 1}",
    views: "2.1M",
    duration: "23m",
  ),
);

// Data RABU
final List<AnimeInfo> rabuAnime = List.generate(
  5,
  (index) => AnimeInfo(
    title: "Oshi no Ko",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1812/134736.jpg",
    rating: 4.9,
    episode: "Eps ${index + 5}",
    isNew: index == 0,
    views: "3.5M",
    duration: "24m",
  ),
);

// Data KAMIS
final List<AnimeInfo> kamisAnime = List.generate(
  3,
  (index) => AnimeInfo(
    title: "Dr. Stone New World",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1674/133982.jpg",
    rating: 4.6,
    episode: "Eps ${index + 3}",
    views: "600k",
    duration: "24m",
  ),
);

// Data JUMAT
final List<AnimeInfo> jumatAnime = List.generate(
  5,
  (index) => AnimeInfo(
    title: "Frieren: Beyond Journey's End",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1015/138006.jpg",
    rating: 4.9,
    episode: "Eps ${index + 10}",
    isNew: true,
    views: "900k",
    duration: "24m",
  ),
);

// Data SABTU
final List<AnimeInfo> sabtuAnime = List.generate(
  7,
  (index) => AnimeInfo(
    title: "Spy x Family",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1441/122795.jpg",
    rating: 4.7,
    episode: "Eps ${index + 15}",
    views: "1.5M",
    duration: "24m",
  ),
);
