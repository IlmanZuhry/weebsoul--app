import 'package:flutter/material.dart';
import '../models/anime_info.dart';
import 'package:weebsoul/services/video_service.dart';
import 'package:weebsoul/services/comment_service.dart';
import 'package:weebsoul/screens/vidio_page.dart';

class DetailPage extends StatefulWidget {
  final AnimeInfo anime;

  const DetailPage({super.key, required this.anime});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int selectedEpisode;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedEpisode = int.tryParse(
          widget.anime.episode.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        1;

    if (widget.anime.episodes.isNotEmpty) {
      final max = widget.anime.episodes.length;
      if (selectedEpisode > max) selectedEpisode = 1;
    }
  }

  Future<void> _openEpisode(int ep) async {
    final videoUrl = await VideoService.getVideoUrl(widget.anime.title, ep);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(
          animeTitle: widget.anime.title,
          title: "${widget.anime.title} - Episode $ep",
          videoUrl: videoUrl,
          description: widget.anime.description,
          episodeCount: widget.anime.episodes.length,
          views: widget.anime.views,
          imageUrl: widget.anime.imageUrl,
        ),
      ),
    );
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final ok = await CommentService.addComment(
      animeTitle: widget.anime.title,
      episodeNumber: selectedEpisode,
      commentText: text,
    );

    if (ok) {
      _commentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambah komentar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(anime.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 12),

            /// POSTER
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  anime.imageUrl,
                  width: 200,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                anime.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// BASIC INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text("Rating: ${anime.rating}",
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(width: 14),
                  Text(anime.type,
                      style: const TextStyle(color: Colors.white54)),
                  const SizedBox(width: 14),
                  Text("${anime.episodes.length} ep",
                      style: const TextStyle(color: Colors.white54)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                anime.description,
                style: const TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            /// EPISODE HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Episodes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// EPISODE LIST
            SizedBox(
              height: 55,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: anime.episodes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final ep = i + 1;
                  final selected = ep == selectedEpisode;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedEpisode = ep);
                      _openEpisode(ep);
                    },
                    child: Container(
                      width: 82,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Ep $ep",
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            /// COMMENT HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.comment, color: Colors.white70),
                  const SizedBox(width: 8),
                  const Text("Komentar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),

                  /// REALTIME COMMENT COUNT
                  StreamBuilder<int>(
                    stream: CommentService.streamCommentCount(
                      anime.title,
                      selectedEpisode,
                    ),
                    builder: (context, snap) {
                      final count = snap.data ?? 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$count",
                          style:
                              const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// COMMENT LIST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: CommentService.streamComments(
                  anime.title,
                  selectedEpisode,
                ),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final list = snap.data!;
                  if (list.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Belum ada komentar.",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return Column(
                    children: list.map((c) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: c['user_avatar'] != null
                                  ? NetworkImage(c['user_avatar'])
                                  : null,
                              child: c['user_avatar'] == null
                                  ? const Icon(Icons.person,
                                      color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c['user_name'] ?? 'Unknown',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Text(c['comment_text'] ?? "",
                                      style: const TextStyle(
                                          color: Colors.white70)),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),

      /// BOTTOM INPUT COMMENT
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: const Color(0xFF181818),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      "Tulis komentar Episode $selectedEpisode...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendComment(),
              ),
            ),
            IconButton(
              onPressed: _sendComment,
              icon: const Icon(Icons.send, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
