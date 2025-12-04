import 'package:flutter/material.dart';
import '../models/anime_info.dart';
import 'package:weebsoul/screens/vidio_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weebsoul/services/video_service.dart';
import 'package:weebsoul/services/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final AnimeInfo anime;

  const DetailPage({super.key, required this.anime});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorited = false;
  bool isLoadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favorited = await FavoriteService.isFavorite(widget.anime.title);
    setState(() {
      isFavorited = favorited;
      isLoadingFavorite = false;
    });
  }

  Future<void> _toggleFavorite() async {
    if (isLoadingFavorite) return;

    setState(() => isLoadingFavorite = true);

    bool success;
    if (isFavorited) {
      success = await FavoriteService.removeFavorite(widget.anime.title);
    } else {
      success = await FavoriteService.addFavorite(widget.anime);
    }

    if (success) {
      setState(() {
        isFavorited = !isFavorited;
        isLoadingFavorite = false;
      });

      // Show feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorited 
                  ? '✅ Ditambahkan ke favorit' 
                  : '❌ Dihapus dari favorit',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: isFavorited ? Colors.green : Colors.red,
          ),
        );
      }
    } else {
      setState(() => isLoadingFavorite = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // 🔥 TITLE + BACK BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.anime.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔥 POSTER VERTIKAL (rasio 1:2)
            Center(
              child: SizedBox(
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Image.network(widget.anime.imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // 🔥 FAVORITE BUTTON (DYNAMIC)
            Center(
              child: SizedBox(
                width: 170,
                height: 42,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFavorited 
                        ? Colors.red.shade700 
                        : const Color(0xFF8B2E2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: isLoadingFavorite
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                  label: Text(
                    isFavorited ? "Favorited" : "Add Favorite",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 GENRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: widget.anime.genres
                    .map(
                      (g) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          g,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.anime.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 EPISODES TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Episodes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 EPISODE LIST
            // 🔥 EPISODE LIST
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.anime.episodes.length,
              itemBuilder: (context, index) {
                
                return GestureDetector(
                  onTap: () async {
                    // ⚡ AMBIL VIDEO URL DARI DATABASE
                    // Extract episode number from string (e.g., "Episode 1" -> 1)
                    final episodeNumber = int.tryParse(
                      widget.anime.episodes[index].replaceAll(RegExp(r'[^0-9]'), '')
                    ) ?? 0;

                    // Fetch video URL from database
                    final videoUrl = await VideoService.getVideoUrl(
                      widget.anime.title,
                      episodeNumber,
                    );

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerPage(
                            animeTitle: widget.anime.title,
                            title: "${widget.anime.title} - ${widget.anime.episodes[index]}",
                            videoUrl: videoUrl, // ⚡ Use fetched URL
                            description: widget.anime.description,
                            episodeCount: widget.anime.episodes.length,
                            views: widget.anime.views,
                          ),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.anime.episodes[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
