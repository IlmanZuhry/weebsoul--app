class AnimeInfo {
  final String title;
  final String imageUrl;
  final double rating;

  // BAGIAN DETAIL
  final String description;
  final List<String> genres;
  final List<String> episodes;

  // FIELD LAMA
  final String episode;
  final String views;
  final String duration;
  final bool isNew;

  AnimeInfo({
    required this.title,
    required this.imageUrl,
    required this.rating,

    required this.description,
    required this.genres,
    required this.episodes,

    required this.episode,
    required this.views,
    required this.duration,
    this.isNew = false,
  });
}
