class AnimeInfo {
  // === DATA UTAMA ===
  final String title;
  final String imageUrl;
  final double rating;
  
  // === FILTERING 
  final String genre; // Genre utama untuk filter (misal: "Action")
  final String type;  // Tipe tayangan (misal: "TV")

  // === DATA DETAIL ===
  final String description;
  final List<String> genres; // List semua genre (misal: ["Action", "Fantasy"])
  final List<String> episodes;

  // === DATA LAINNYA ===
  final String episode; // Episode terakhir/saat ini (string)
  final String views;
  final String duration;
  final bool isNew;

  AnimeInfo({
    required this.title,
    required this.imageUrl,
    required this.rating,
    
    // Default value diberikan agar data lama yang belum punya genre/type tidak error
    this.genre = "Action", 
    this.type = "TV",

    required this.description,
    required this.genres,
    required this.episodes,

    required this.episode,
    required this.views,
    required this.duration,
    this.isNew = false,
  });
}