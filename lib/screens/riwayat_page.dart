import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  // ⭐ Warna Biru Kustom (Mirip referensi gambar '2 Anime')
  final Color accentBlue = const Color(0xFF29B6F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // ==============================================
            // ⭐ HEADER AESTHETIC (TEMA BIRU)
            // ==============================================
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                // Gradient Biru ke Gelap
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightBlueAccent.withOpacity(0.3), // Biru transparan
                    const Color(0xFF1E1E1E), // Menyatu ke background
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  // Dekorasi Ikon Background
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(
                      Icons.history,
                      size: 140,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),

                  // Text Judul
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Daftar Aktivitas",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Riwayat Menonton",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26, // Ukuran font diperbesar sedikit
                            fontWeight: FontWeight.w900, // Lebih tebal (Bold)
                            letterSpacing:
                                0.5, // Spasi antar huruf biar tidak kaku
                            fontFamily:
                                'Roboto', // Pastikan font default terlihat bagus
                            shadows: [
                              BoxShadow(
                                color: accentBlue.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==============================================
            // ISI LIST
            // ==============================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Group 1: 13 Hari Lalu
                    HistoryDateSection(
                      date: "13 hari lalu",
                      accentColor: accentBlue,
                      children: [
                        HistoryItem(
                          img:
                              "https://cdn.myanimelist.net/images/anime/1078/144598.jpg",
                          title: "Nageki no Bourei wa Intai shitai Season 2",
                          episode: "Episode 4",
                          watchedTime: "08:28",
                          totalTime: "23:50",
                          progress: 0.35,
                          accentColor: accentBlue,
                        ),
                      ],
                    ),

                    // Group 2: 29 Hari Lalu
                    HistoryDateSection(
                      date: "29 hari lalu",
                      accentColor: accentBlue,
                      children: [
                        HistoryItem(
                          img:
                              "https://awsimages.detik.net.id/community/media/visual/2025/03/09/one-punch-man-season-3-1741505097754.jpeg?w=700&q=90",
                          title: "One Punch Man Season 3",
                          episode: "Episode 1",
                          watchedTime: "08:04",
                          totalTime: "24:01",
                          progress: 0.33,
                          accentColor: accentBlue,
                        ),
                      ],
                    ),

                    // Group 3: Tanggal Spesifik
                    HistoryDateSection(
                      date: "05 Oct 2025",
                      accentColor: accentBlue,
                      children: [
                        HistoryItem(
                          img:
                              "https://cdn.myanimelist.net/images/anime/1257/127166.jpg",
                          title: "Witch Watch",
                          episode: "Episode 25",
                          watchedTime: "19:59",
                          totalTime: "24:02",
                          progress: 0.8,
                          accentColor: accentBlue,
                        ),
                      ],
                    ),

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
}

// ======================================================
// WIDGET PENDUKUNG
// ======================================================

class HistoryDateSection extends StatelessWidget {
  final String date;
  final List<Widget> children;
  final Color accentColor;

  const HistoryDateSection({
    super.key,
    required this.date,
    required this.children,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Garis vertikal kecil warna biru
            Container(
              height: 18,
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.6),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...children,
        const SizedBox(height: 10),
      ],
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String img;
  final String title;
  final String episode;
  final String watchedTime;
  final String totalTime;
  final double progress;
  final Color accentColor;

  const HistoryItem({
    super.key,
    required this.img,
    required this.title,
    required this.episode,
    required this.watchedTime,
    required this.totalTime,
    required this.progress,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(
          0xFF252525,
        ), // Sedikit lebih terang dari background utama
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              img,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Tulisan Episode jadi Biru
                Text(
                  episode,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      watchedTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    Text(
                      totalTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Progress Bar Biru
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: Colors.black45,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
