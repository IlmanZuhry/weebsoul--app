class AnimeInfo {
  final String title;
  final String episode;
  final String imageUrl;
  final double rating;
  final String views;
  final String duration;
  final bool isNew;

  AnimeInfo({
    required this.title,
    required this.episode,
    required this.imageUrl,
    required this.rating,
    required this.views,
    required this.duration,
    this.isNew = false,
  });
}
