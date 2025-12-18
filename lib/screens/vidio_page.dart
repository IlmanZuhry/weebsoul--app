import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:weebsoul/services/video_service.dart';
import 'package:weebsoul/services/comment_service.dart';
import 'package:weebsoul/services/watch_history_service.dart';
import 'package:weebsoul/services/like_service.dart'; // Import service baru
import 'dart:async';

class VideoPlayerPage extends StatefulWidget {
  final String animeTitle;
  final String title;
  final String videoUrl;
  final String description;
  final int episodeCount;
  final String views;
  final String imageUrl;

  const VideoPlayerPage({
    super.key,
    required this.animeTitle,
    required this.title,
    required this.videoUrl,
    required this.description,
    required this.episodeCount,
    required this.views,
    required this.imageUrl,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late int selectedEpisode;
  int selectedFilter = 0;

  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  List<Map<String, dynamic>> comments = [];
  bool isLoadingComments = true;
  final TextEditingController _commentController = TextEditingController();

  Timer? _progressTimer;
  String? _currentImageUrl;
  
  bool isUserLiked = false;

  @override
  void initState() {
    super.initState();

    final parts = widget.title.split("Episode ");
    selectedEpisode = int.tryParse(parts.last) ?? 1;

    _currentImageUrl = widget.imageUrl;

    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
        );
        setState(() {});
        _startWatchHistoryTracking();
      });

    _loadComments();
    _checkInitialLikeStatus();
  }

  Future<void> _checkInitialLikeStatus() async {
    final status = await LikeService.isLiked(
      animeTitle: widget.animeTitle,
      episodeNumber: selectedEpisode,
    );
    if (mounted) {
      setState(() => isUserLiked = status);
    }
  }

  Future<void> _handleLikeToggle() async {
    setState(() => isUserLiked = !isUserLiked);
    await LikeService.toggleLike(
      animeTitle: widget.animeTitle,
      episodeNumber: selectedEpisode,
    );
  }

  Future<void> _loadComments() async {
    setState(() => isLoadingComments = true);
    final fetchedComments = await CommentService.getComments(
      widget.animeTitle,
      selectedEpisode,
    );
    setState(() {
      comments = fetchedComments;
      isLoadingComments = false;
    });
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final success = await CommentService.addComment(
      animeTitle: widget.animeTitle,
      episodeNumber: selectedEpisode,
      commentText: _commentController.text.trim(),
    );

    if (success) {
      _commentController.clear();
      _loadComments();
    }
  }

  void _startWatchHistoryTracking() {
    _saveWatchHistory();

    _progressTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_videoController.value.isInitialized &&
          _videoController.value.isPlaying) {
        _updateProgress();
      }
    });
  }

  Future<void> _saveWatchHistory() async {
    if (!_videoController.value.isInitialized) return;

    await WatchHistoryService.saveWatchHistory(
      animeTitle: widget.animeTitle,
      episodeNumber: selectedEpisode,
      watchedDuration: _videoController.value.position.inSeconds,
      totalDuration: _videoController.value.duration.inSeconds,
      imageUrl: _currentImageUrl ?? '',
      episodeLabel: "Episode $selectedEpisode",
    );
  }

  Future<void> _updateProgress() async {
    if (!_videoController.value.isInitialized) return;

    await WatchHistoryService.updateProgress(
      animeTitle: widget.animeTitle,
      episodeNumber: selectedEpisode,
      watchedDuration: _videoController.value.position.inSeconds,
    );
  }

  @override
  void dispose() {
    _updateProgress();
    _progressTimer?.cancel();
    _videoController.dispose();
    _chewieController?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLandscape
                    ? Expanded(
                        child: Center(
                          child: _chewieController != null &&
                                  _videoController.value.isInitialized
                              ? Chewie(controller: _chewieController!)
                              : const CircularProgressIndicator(
                                  color: Colors.white),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _chewieController != null &&
                                _videoController.value.isInitialized
                            ? Chewie(controller: _chewieController!)
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                      ),

                if (!isLandscape)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.animeTitle} - Episode $selectedEpisode",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              Text(
                                "Episode $selectedEpisode • ",
                                style:
                                    const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              const Icon(Icons.visibility,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.views} • 3 Dec 2025",
                                style:
                                    const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<int>(
                                stream: LikeService.streamLikeCount(
                                  animeTitle: widget.animeTitle,
                                  episodeNumber: selectedEpisode,
                                ),
                                builder: (context, snapshot) {
                                  final count = snapshot.data ?? 0;
                                  return GestureDetector(
                                    onTap: _handleLikeToggle,
                                    child: _buildInfoButton(
                                      isUserLiked ? Icons.thumb_up : Icons.thumb_up_outlined, 
                                      count.toString(),
                                      color: isUserLiked ? Colors.blueAccent : Colors.white,
                                    ),
                                  );
                                }
                              ),
                              _buildInfoButton(Icons.message, comments.length.toString()),
                              _buildInfoButton(Icons.hd, "360p"),
                              _buildInfoButton(Icons.download, "Download"),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Episode List",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            height: 60,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.episodeCount,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final ep = index + 1;

                                return GestureDetector(
                                  onTap: () async {
                                    final nextUrl = await VideoService.getVideoUrl(
                                      widget.animeTitle,
                                      ep,
                                    );

                                    if (!context.mounted) return;

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoPlayerPage(
                                          animeTitle: widget.animeTitle,
                                          title: "Episode $ep",
                                          videoUrl: nextUrl,
                                          description: widget.description,
                                          episodeCount: widget.episodeCount,
                                          views: widget.views,
                                          imageUrl: widget.imageUrl,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 55,
                                    decoration: BoxDecoration(
                                      color: ep == selectedEpisode
                                          ? Colors.white
                                          : Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$ep",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ep == selectedEpisode
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "Jangan lupa untuk membuat komentar yang sopan dan santun dan mengikuti ",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Aturan Komunitas",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Komentar",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              _filterButton("Top Comment", 0),
                              const SizedBox(width: 12),
                              _filterButton("Terbaru", 1),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent,
                                ),
                                child:
                                    const Icon(Icons.person, color: Colors.white),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  style:
                                      const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.shade800,
                                    hintText: "Tambahkan komentar...",
                                    hintStyle: const TextStyle(
                                        color: Colors.white54),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.white54),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.send,
                                          color: Colors.blueAccent),
                                      onPressed: _submitComment,
                                    ),
                                  ),
                                  onSubmitted: (_) => _submitComment(),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          isLoadingComments
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                )
                              : comments.isEmpty
                                  ? _emptyCommentBox()
                                  : Column(
                                      children: comments.map((comment) {
                                        return _buildComment(
                                          avatarUrl: comment['user_avatar'] ??
                                              'https://ui-avatars.com/api/?name=${comment['user_name']}&background=random',
                                          name: comment['user_name'] ??
                                              'Anonymous',
                                          time:
                                              _formatTime(comment['created_at']),
                                          comment:
                                              comment['comment_text'] ?? '',
                                        );
                                      }).toList(),
                                    ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _filterButton(String text, int id) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color:
              selectedFilter == id ? Colors.white : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedFilter == id ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _emptyCommentBox() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.comment_outlined,
              size: 64,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 16),
            Text(
              "Belum ada komentar",
              style:
                  TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Jadilah yang pertama berkomentar!",
              style:
                  TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? timestamp) {
    try {
      if (timestamp == null) return "Baru saja";

      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return "Baru saja";
      if (diff.inMinutes < 60) return "${diff.inMinutes} menit lalu";
      if (diff.inHours < 24) return "${diff.inHours} jam lalu";
      if (diff.inDays < 7) return "${diff.inDays} hari lalu";
      return "${(diff.inDays / 7).floor()} minggu lalu";
    } catch (e) {
      return "Baru saja";
    }
  }

  Widget _buildInfoButton(IconData icon, String label, {Color color = Colors.white}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildComment({
    required String avatarUrl,
    required String name,
    required String time,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "• $time",
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  comment,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined,
                        color: Colors.white70, size: 20),
                    const SizedBox(width: 25),
                    const Icon(Icons.thumb_down_outlined,
                        color: Colors.white70, size: 20),
                    const SizedBox(width: 45),
                    const Icon(Icons.message_sharp,
                        color: Colors.white70, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}