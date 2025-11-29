import 'package:flutter/material.dart';
import 'package:weebsoul/data/anime_data.dart';
import 'package:weebsoul/models/anime_info.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  // ⭐ Warna Aksen Biru (Sama seperti Riwayat Page)
  final Color accentBlue = const Color(0xFF29B6F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // ==============================================
            // ⭐ HEADER AESTHETIC (FIXED HEIGHT)
            // ==============================================
            Container(
              width: double.infinity,
              height: 130, // ✅ SUDAH DIPERBESAR (Biar teks tidak kepotong)
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightBlueAccent.withOpacity(0.3),
                    const Color(0xFF1E1E1E),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Icon(
                      Icons.calendar_month, // Icon Kalender
                      size: 100,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Update Mingguan",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Jadwal Rilis",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==============================================
            // CONTENT SCROLLABLE
            // ==============================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    _buildDaySection(
                      day: "Minggu",
                      count: 18,
                      animeList: mingguAnime,
                    ),
                    _buildDaySection(
                      day: "Senin",
                      count: 2,
                      animeList: seninAnime,
                    ),
                    _buildDaySection(
                      day: "Selasa",
                      count: 7,
                      animeList: selasaAnime,
                    ),
                    _buildDaySection(
                      day: "Rabu",
                      count: 5,
                      animeList: rabuAnime,
                    ),
                    _buildDaySection(
                      day: "Kamis",
                      count: 8,
                      animeList: kamisAnime,
                    ),
                    _buildDaySection(
                      day: "Jumat",
                      count: 10,
                      animeList: jumatAnime,
                    ),
                    _buildDaySection(
                      day: "Sabtu",
                      count: 12,
                      animeList: sabtuAnime,
                    ),
                    const SizedBox(
                      height: 80,
                    ), // Spacer bawah agar tidak ketutup navbar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // WIDGET HARI
  // =====================================================================
  Widget _buildDaySection({
    required String day,
    required int count,
    required List<AnimeInfo> animeList,
  }) {
    // Tinggi area grid (disesuaikan agar kartu tidak gepeng)
    const double sectionHeight = 320;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDayHeader(day, count),

        SizedBox(
          height: sectionHeight,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  1, // 1 Baris saja biar scroll samping enak dilihat
              mainAxisSpacing: 12,
              childAspectRatio: 1.45, // Mengatur rasio tinggi:lebar kartu
            ),
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              return _buildAnimeCard(animeList[index]);
            },
          ),
        ),
      ],
    );
  }

  // =====================================================================
  // HEADER HARI (Gaya Garis Vertikal - Selaras Riwayat Page)
  // =====================================================================
  Widget _buildDayHeader(String day, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        children: [
          // Garis Vertikal Biru
          Container(
            height: 24,
            width: 4,
            decoration: BoxDecoration(
              color: accentBlue,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: accentBlue.withOpacity(0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Nama Hari
          Text(
            day,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 8),

          // Jumlah Anime (Warna Biru)
          Text(
            "$count Anime",
            style: TextStyle(
              fontSize: 18,
              color: accentBlue, // Biru neon
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // CARD ANIME (Updated Style - Selaras Riwayat Page)
  // =====================================================================
  Widget _buildAnimeCard(AnimeInfo anime) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252525), // Background kartu sedikit lebih terang
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ), // Border tipis
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Gambar
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    anime.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),

                // Rating Badge (Pojok Kanan Atas)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          anime.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Episode Badge (Pojok Kiri Bawah Gambar)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      anime.episode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bagian Informasi Teks
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    anime.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Row Icon Views & Jam
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        "${anime.views} v",
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        anime.duration,
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
