import 'package:flutter/material.dart';
import 'package:weebsoul/data/anime_data.dart';
import 'package:weebsoul/models/anime_info.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  // Warna Aksen Biru (Konsisten dengan page lain)
  final Color accentBlue = const Color(0xFF29B6F6);

  @override
  Widget build(BuildContext context) {
    // 💡 SEMENTARA: Kita gabungkan beberapa data anime biar terlihat banyak
    // Nanti bisa diganti dengan logic database/local storage yang asli
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
            // ⭐ HEADER AESTHETIC (Style Favorit)
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
                  // Icon Background Transparan
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Icon(
                      Icons.favorite, // Ikon Hati
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
            // GRID CONTENT
            // ==============================================
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 Kolom ke samping
                  crossAxisSpacing: 12, // Jarak antar kolom
                  mainAxisSpacing: 12, // Jarak antar baris
                  childAspectRatio:
                      0.70, // Rasio tinggi:lebar kartu (Poster Style)
                ),
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  return _buildFavoriteCard(favoriteList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // KARTU ANIME (Updated Style - Sesuai Request)
  // =====================================================================
  Widget _buildFavoriteCard(AnimeInfo anime) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF252525,
        ), // Background kartu agak terang dikit dari BG utama
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ), // Border tipis
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Gambar (Expanded biar menuhin area atas)
          Expanded(
            flex: 3, // Proporsi gambar lebih besar
            child: Stack(
              children: [
                // Gambar Anime
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

                // ⭐ RATING BADGE (Pojok Kanan Atas)
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
                        const Icon(Icons.star, color: Colors.amber, size: 10),
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

                // ⭐ EPISODE BADGE (Pojok Kiri Bawah - Overlay Gambar)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: accentBlue, // Warna biru
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      anime.episode, // Contoh: "Episode 7"
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

          // Bagian Teks Bawah (Hanya Judul)
          Expanded(
            flex: 2, // Proporsi teks
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
