import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  final String image;
  final String eps;
  final String rating;
  final String views;
  final String title;

  const AnimeCard({
    super.key,
    required this.image,
    required this.eps,
    required this.rating,
    required this.views,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.42;
    final imageHeight = cardWidth * 1.2;

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              height: imageHeight,
              width: cardWidth,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(eps, style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              const Icon(Icons.visibility, color: Colors.white54, size: 16),
              const SizedBox(width: 4),
              Text(views, style: const TextStyle(color: Colors.white54)),
            ],
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
