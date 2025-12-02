import 'package:flutter/material.dart';
import 'package:weebsoul/data/anime_data.dart';
import 'package:weebsoul/models/anime_info.dart';
import 'package:weebsoul/screens/detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  final Color accentBlue = const Color(0xFF29B6F6);

  @override
  Widget build(BuildContext context) {
    // Menggabungkan beberapa data anime untuk simulasi Favorit
    final List<AnimeInfo> favoriteList = [
      ...mingguAnime,
      ...seninAnime,
      ...selasaAnime,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // ==============================================
            // HEADER FAVORIT
            // ==============================================
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
                      Icons.favorite,
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
                            "Koleksi Pribadi",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Anime Favorit",
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
            // GRID CONTENT (PERBAIKAN TAMPILAN)
            // ==============================================
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 Kolom agar pas seperti di Home
                  crossAxisSpacing: 12, // Jarak antar kolom
                  mainAxisSpacing: 16, // Jarak antar baris
                  childAspectRatio:
                      0.65, // 🔥 FIX: Rasio ini membuat kartu proporsional (tidak gepeng/panjang)
                ),
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  return _buildFavoriteCard(context, favoriteList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // KARTU ANIME (Desain diperbaiki)
  // ===============================================================
  Widget _buildFavoriteCard(BuildContext context, AnimeInfo anime) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Detail Page saat diklik
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(anime: anime)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAGIAN GAMBAR & RATING
          Expanded(
            child: Stack(
              children: [
                // Gambar Anime
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    anime.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white54),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),

                // Rating Badge (Pojok Kanan Atas)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 10),
                        const SizedBox(width: 3),
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
              ],
            ),
          ),

          const SizedBox(height: 8),

          // JUDUL (Maksimal 2 baris)
          Text(
            anime.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.2, // Jarak antar baris teks biar rapi
            ),
          ),
        ],
      ),
    );
  }
}
