import 'package:flutter/material.dart';
import 'package:weebsoul/services/watch_history_service.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  // ⭐ Warna Biru Kustom
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
            // ==============================================
            // ⭐ HEADER AESTHETIC (TEMA BIRU)
            // ==============================================
            Container(
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
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
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
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            fontFamily: 'Roboto',
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
            // ISI LIST (DINAMIS DARI DATABASE)
            // ==============================================
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

  Widget _buildHistoryContent() {
    // Check if there's any history
    final hasHistory = groupedHistory.values.any((list) => list.isNotEmpty);

    if (!hasHistory) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 16),
            Text(
              "Belum ada riwayat tontonan",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Mulai menonton anime untuk melihat riwayat",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // SECTION 1: Baru Saja
            if (groupedHistory['Baru Saja']!.isNotEmpty)
              _buildHistorySection(
                date: "Baru Saja",
                historyList: groupedHistory['Baru Saja']!,
              ),

            // SECTION 2: Minggu Ini
            if (groupedHistory['Minggu Ini']!.isNotEmpty)
              _buildHistorySection(
                date: "Minggu Ini",
                historyList: groupedHistory['Minggu Ini']!,
              ),

            // SECTION 3: Bulan Lalu
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

  // ======================================================
  // FUNGSI BUILDER UNTUK GROUP HISTORY
  // ======================================================
  Widget _buildHistorySection({
    required String date,
    required List<Map<String, dynamic>> historyList,
  }) {
    return HistoryDateSection(
      date: date,
      accentColor: accentBlue,
      children: historyList.map((history) {
        // Calculate progress
        final watchedDuration = history['watched_duration'] ?? 0;
        final totalDuration = history['total_duration'] ?? 1;
        final progress = (watchedDuration / totalDuration).clamp(0.0, 1.0);

        // Format time
        final watchedTime = _formatDuration(watchedDuration);
        final totalTime = _formatDuration(totalDuration);

        return HistoryItem(
          img: history['image_url'] ?? '',
          title: history['anime_title'] ?? 'Unknown',
          episode: history['anime_episode_label'] ?? 'Episode ${history['episode_number']}',
          watchedTime: watchedTime,
          totalTime: totalTime,
          progress: progress,
          accentColor: accentBlue,
        );
      }).toList(),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

// ======================================================
// WIDGET PENDUKUNG (TIDAK BERUBAH)
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
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: img.isNotEmpty
                ? Image.network(
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
                  )
                : Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[800],
                    child: const Icon(Icons.movie, color: Colors.white54),
                  ),
          ),
          const SizedBox(width: 15),

          // Info Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                // Judul
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

                // Episode (Biru)
                Text(
                  episode,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Waktu
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

                // Progress Bar
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