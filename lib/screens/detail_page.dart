import 'package:flutter/material.dart';
import '../models/anime_info.dart';
import 'package:weebsoul/screens/vidio_page.dart';
import 'package:weebsoul/services/video_service.dart';
import 'package:weebsoul/services/favorite_service.dart';
import 'package:weebsoul/services/comment_service.dart';

class DetailPage extends StatefulWidget {
  final AnimeInfo anime;

  const DetailPage({super.key, required this.anime});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorited = false;
  bool isLoadingFavorite = true;
  int selectedEpisodeForComment = 1;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    
    selectedEpisodeForComment = int.tryParse(
      widget.anime.episode.replaceAll(RegExp(r'[^0-9]'), ''),
    ) ?? 1;
  }

  Future<void> _checkFavoriteStatus() async {
    final favorited = await FavoriteService.isFavorite(widget.anime.title);
    if (mounted) {
      setState(() {
        isFavorited = favorited;
        isLoadingFavorite = false;
      });
    }
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorited ? '✅ Ditambahkan ke favorit' : '❌ Dihapus dari favorit',
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

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final ok = await CommentService.addComment(
      animeTitle: widget.anime.title,
      episodeNumber: selectedEpisodeForComment,
      commentText: text,
    );

    if (ok) {
      _commentController.clear();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambah komentar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
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

                Center(
                  child: SizedBox(
                    width: 170,
                    height: 42,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorited ? Colors.red.shade700 : const Color(0xFF8B2E2E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: isLoadingFavorite
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(isFavorited ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                      label: Text(
                        isFavorited ? "Favorited" : "Add Favorite",
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text("Rating: ${widget.anime.rating}", style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 14),
                      Text(widget.anime.type, style: const TextStyle(color: Colors.white54)),
                      const SizedBox(width: 14),
                      Text("${widget.anime.episodes.length} ep", style: const TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.anime.genres.map((g) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(g, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    )).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.anime.description,
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                  ),
                ),

                const SizedBox(height: 25),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Episodes",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.anime.episodes.length,
                  itemBuilder: (context, index) {
                    final epNum = int.tryParse(widget.anime.episodes[index].replaceAll(RegExp(r'[^0-9]'), '')) ?? (index + 1);
                    return GestureDetector(
                      onTap: () async {
                        setState(() => selectedEpisodeForComment = epNum);
                        final videoUrl = await VideoService.getVideoUrl(widget.anime.title, epNum);
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerPage(
                                animeTitle: widget.anime.title,
                                title: "${widget.anime.title} - ${widget.anime.episodes[index]}",
                                startAtSeconds: 0,
                                videoUrl: videoUrl,
                                description: widget.anime.description,
                                episodeCount: widget.anime.episodes.length,
                                views: widget.anime.views.toString(),
                                imageUrl: widget.anime.imageUrl,
                                episodeNumber: epNum,
                              ),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                            color: epNum == selectedEpisodeForComment ? Colors.white12 : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(10),
                            border: epNum == selectedEpisodeForComment ? Border.all(color: Colors.white24) : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.anime.episodes[index], style: const TextStyle(color: Colors.white, fontSize: 15)),
                              const Icon(Icons.play_arrow, color: Colors.white, size: 26),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.comment, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text("Komentar Ep $selectedEpisodeForComment",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      StreamBuilder<int>(
                        stream: CommentService.streamCommentCount(widget.anime.title, selectedEpisodeForComment),
                        builder: (context, snap) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(8)),
                            child: Text("${snap.data ?? 0}", style: const TextStyle(color: Colors.white, fontSize: 14)),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: CommentService.streamComments(widget.anime.title, selectedEpisodeForComment),
                    builder: (context, snap) {
                      if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                      final list = snap.data!;
                      if (list.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Belum ada komentar.", style: TextStyle(color: Colors.white54)),
                        );
                      }
                      return Column(
                        children: list.map((c) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: c['user_avatar'] != null ? NetworkImage(c['user_avatar']) : null,
                                child: c['user_avatar'] == null ? const Icon(Icons.person, color: Colors.white) : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['user_name'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(c['comment_text'] ?? "", style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )).toList(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: const Color(0xFF181818),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Tulis komentar Ep $selectedEpisodeForComment...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _sendComment(),
                    ),
                  ),
                  IconButton(onPressed: _sendComment, icon: const Icon(Icons.send, color: Colors.blueAccent)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}