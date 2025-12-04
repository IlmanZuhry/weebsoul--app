import 'package:flutter/material.dart';
import 'package:weebsoul/models/anime_info.dart';
import 'package:weebsoul/screens/detail_page.dart';
import 'package:weebsoul/services/favorite_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final Color accentBlue = const Color(0xFF29B6F6);
  List<AnimeInfo> favoriteList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);
    
    final favorites = await FavoriteService.getFavorites();
    
    // Convert favorites data to complete AnimeInfo objects
    final animeList = favorites.map((fav) {
      return AnimeInfo(
        title: fav['anime_title'] ?? '',
        imageUrl: fav['anime_image_url'] ?? '',
        rating: (fav['anime_rating'] as num?)?.toDouble() ?? 0.0,
        episode: fav['anime_episode'] ?? 'Favorited',
        views: fav['anime_views'] ?? '0',
        duration: fav['anime_duration'] ?? '0',
        description: fav['anime_description'] ?? '',
        genres: (fav['anime_genres'] as String?)?.split(',') ?? [],
        episodes: (fav['anime_episodes'] as String?)?.split(',') ?? [],
      );
    }).toList();

    setState(() {
      favoriteList = animeList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // GRID CONTENT (DYNAMIC)
            // ==============================================
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : favoriteList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 80,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Belum ada favorit",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Tambahkan anime favorit Anda\ndari halaman detail",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
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
  // KARTU ANIME
  // ===============================================================
  Widget _buildFavoriteCard(BuildContext context, AnimeInfo anime) {
    return GestureDetector(
      onTap: () async {
        // Navigasi ke Detail Page saat diklik
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(anime: anime)),
        );
        // Reload favorites setelah kembali (jika ada perubahan)
        _loadFavorites();
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
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}