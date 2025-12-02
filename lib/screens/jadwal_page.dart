import 'package:flutter/material.dart';
import 'package:weebsoul/data/anime_data.dart';
import 'package:weebsoul/models/anime_info.dart';
import 'package:weebsoul/screens/detail_page.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  final Color accentBlue = const Color(0xFF29B6F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              height: 130,
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
                      Icons.calendar_month,
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

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    _buildDaySection(day: "Minggu", animeList: mingguAnime),
                    _buildDaySection(day: "Senin", animeList: seninAnime),
                    _buildDaySection(day: "Selasa", animeList: selasaAnime),
                    _buildDaySection(day: "Rabu", animeList: rabuAnime),
                    _buildDaySection(day: "Kamis", animeList: kamisAnime),
                    _buildDaySection(day: "Jumat", animeList: jumatAnime),
                    _buildDaySection(day: "Sabtu", animeList: sabtuAnime),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection({
    required String day,
    required List<AnimeInfo> animeList,
  }) {
    // Tinggi Section List Horizontal
    // Dihitung dari Tinggi Gambar (160) + Teks (40) + Padding
    const double sectionHeight = 230;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDayHeader(day, animeList.length),

        SizedBox(
          height: sectionHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: animeList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildAnimeCard(context, animeList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader(String day, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12), // Padding disesuaikan
      child: Row(
        children: [
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
          Text(
            day,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$count Anime",
            style: TextStyle(
              fontSize: 18,
              color: accentBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // ⭐ CARD STYLE DARI HOME PAGE
  // ===============================================================
  Widget _buildAnimeCard(BuildContext context, AnimeInfo anime) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(anime: anime)),
        );
      },
      child: SizedBox(
        width: 120, // Lebar item fixed agar pas
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    anime.imageUrl,
                    width: 120,
                    height: 160, // Tinggi gambar fixed
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      height: 160,
                      width: 120,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),

                // ⭐ RATING BADGE
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          anime.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              anime.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
