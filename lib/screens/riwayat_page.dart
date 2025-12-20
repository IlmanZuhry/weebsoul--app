import 'package:flutter/material.dart';
import 'package:weebsoul/services/watch_history_service.dart';
import 'package:weebsoul/services/video_service.dart';
import 'package:weebsoul/screens/vidio_page.dart';
// IMPORT WAJIB: Supaya data deskripsi & episode list tidak hilang
import 'package:weebsoul/data/anime_data.dart';
import 'package:weebsoul/models/anime_info.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final Color accentBlue = const Color(0xFF29B6F6);

  Map<String, List<Map<String, dynamic>>> groupedHistory = {
    'Baru Saja': [],
    'Minggu Ini': [],
    'Bulan Lalu': [],
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWatchHistory();
  }

  Future<void> _loadWatchHistory() async {
    setState(() => isLoading = true);
    final history = await WatchHistoryService.getWatchHistoryGrouped();
    setState(() {
      groupedHistory = history;
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
            _buildHeader(),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF29B6F6),
                      ),
                    )
                  : _buildHistoryContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.lightBlueAccent.withOpacity(0.3),
            const Color(0xFF1E1E1E),
          ],
        ),
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.history,
              size: 140,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Daftar Aktivitas",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Riwayat Menonton",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent() {
    final hasHistory = groupedHistory.values.any((e) => e.isNotEmpty);
    if (!hasHistory) {
      return const Center(
        child: Text(
          "Belum ada riwayat tontonan",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWatchHistory,
      color: accentBlue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (groupedHistory['Baru Saja']!.isNotEmpty)
              _buildHistorySection(
                date: "Baru Saja",
                historyList: groupedHistory['Baru Saja']!,
              ),
            if (groupedHistory['Minggu Ini']!.isNotEmpty)
              _buildHistorySection(
                date: "Minggu Ini",
                historyList: groupedHistory['Minggu Ini']!,
              ),
            if (groupedHistory['Bulan Lalu']!.isNotEmpty)
              _buildHistorySection(
                date: "Bulan Lalu",
                historyList: groupedHistory['Bulan Lalu']!,
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection({
    required String date,
    required List<Map<String, dynamic>> historyList,
  }) {
    return HistoryDateSection(
      date: date,
      accentColor: accentBlue,
      children: historyList.map((history) {
        final watched = _toInt(history['watched_duration']);
        final total = _toInt(history['total_duration'], fallback: 1);
        final progress = (watched / total).clamp(0.0, 1.0);

        final String animeTitle = (history['anime_title'] ?? 'Unknown')
            .toString();
        final int episodeNum = _toInt(history['episode_number'], fallback: 1);
        final String imageUrl = (history['image_url'] ?? '').toString();

        return HistoryItem(
          img: imageUrl,
          title: animeTitle,
          episode: (history['anime_episode_label'] ?? 'Episode $episodeNum')
              .toString(),
          watchedTime: _formatDuration(watched),
          totalTime: _formatDuration(total),
          progress: progress,
          accentColor: accentBlue,
          onTap: () async {
            // Loading Dialog agar user tahu proses sedang berjalan
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (c) => const Center(child: CircularProgressIndicator()),
            );

            try {
              // 1. CARI DATA LENGKAP DARI FILE LOKAL (SINKRONISASI)
              final allAnime = [
                ...ongoingAnime,
                ...completedAnime,
                ...mingguAnime,
              ];
              AnimeInfo? foundAnime;
              try {
                foundAnime = allAnime.firstWhere(
                  (anime) =>
                      anime.title.trim().toLowerCase() ==
                      animeTitle.trim().toLowerCase(),
                );
              } catch (_) {
                foundAnime = null;
              }

              // 2. AMBIL URL TERBARU (Link streaming)
              final videoUrl = await VideoService.getVideoUrl(
                animeTitle,
                episodeNum,
              );

              if (!mounted) return;
              Navigator.pop(context); // Tutup loading

              // 3. KIRIM DATA LENGKAP KE PLAYER AGAR DESKRIPSI & LIST EPISODE MUNCUL
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerPage(
                    animeTitle: animeTitle,
                    episodeNumber: episodeNum,
                    title:
                        history['anime_episode_label'] ?? "Episode $episodeNum",
                    videoUrl: videoUrl,
                    startAtSeconds: watched, // RESUME KE DETIK TERAKHIR
                    imageUrl: imageUrl,
                    description:
                        foundAnime?.description ?? "Deskripsi tidak tersedia.",
                    episodeCount: foundAnime?.episodes.length ?? episodeNum,
                    views: foundAnime?.views ?? "0",
                  ),
                ),
              ).then((_) => _loadWatchHistory()); // Refresh saat balik
            } catch (e) {
              if (mounted) Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gagal memuat video")),
              );
            }
          },
        );
      }).toList(),
    );
  }

  int _toInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    return int.tryParse(value.toString()) ?? (value is int ? value : fallback);
  }

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    return '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}

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
        const SizedBox(height: 10),
        Text(
          date,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ...children,
      ],
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String img, title, episode, watchedTime, totalTime;
  final double progress;
  final Color accentColor;
  final VoidCallback onTap;

  const HistoryItem({
    super.key,
    required this.img,
    required this.title,
    required this.episode,
    required this.watchedTime,
    required this.totalTime,
    required this.progress,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF252525),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  img,
                  width: 90,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(width: 90, height: 70, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      episode,
                      style: TextStyle(color: accentColor, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white10,
                      color: accentColor,
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          watchedTime,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          totalTime,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
