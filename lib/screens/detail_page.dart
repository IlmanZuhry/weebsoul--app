import 'package:flutter/material.dart';
import '../models/anime_info.dart';
import 'package:weebsoul/screens/vidio_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPage extends StatelessWidget {
  final AnimeInfo anime;

  const DetailPage({super.key, required this.anime});

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
                      anime.title,
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
                width: 200, // << ubah 200 → 180 jika ingin lebih kecil
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3 / 4, // rasio vertikal
                    child: Image.network(anime.imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // 🔥 FAVORITE BUTTON
            Center(
              child: SizedBox(
                width: 170,
                height: 42,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF8B2E2E,
                    ), // merah maroon seperti contoh
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.video_library, color: Colors.white),
                  label: const Text(
                    "Add Favorite",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 GENRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: anime.genres
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
                anime.description,
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
              itemCount: anime.episodes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 🔥 LOGIKA UNTUK VIDEO SPY X FAMILY EPISODE 1 (SUPABASE)
                    String videoUrlToUse = "https://samplelib.com/lib/preview/mp4/sample-5s.mp4"; // Default Dummy

                    // Cek jika ini adalah Spy x Family dan Episode 1
                    if (anime.title.contains("Spy x Family") && anime.episodes[index] == "Episode 1") {
                      // ⚡ AMBIL DARI SUPABASE STORAGE
                      // Pastikan Anda sudah membuat bucket bernama 'Vidio_Anime' dan upload file 'spyeps1.mp4'
                      final supabase = Supabase.instance.client;
                      videoUrlToUse = supabase
                          .storage
                          .from('Vidio_Anime') // Nama bucket
                          .getPublicUrl('spyeps1.mp4'); // Nama file yang diupload
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(
                          animeTitle: anime.title,
                          title: "${anime.title} - ${anime.episodes[index]}",
                          videoUrl: videoUrlToUse,
                          description: anime.description,
                          episodeCount: anime.episodes.length,
                          views: anime.views,
                        ),
                      ),
                    );
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
                            anime.episodes[index],
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
