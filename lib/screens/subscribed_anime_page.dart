import 'package:flutter/material.dart';
import 'anime_card.dart';

class SubscribedAnimePage extends StatelessWidget {
  const SubscribedAnimePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.width * 0.42 * 1.2 + 60;

    final completedList = [
      {
        "image": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vidio.com%2Fpremier%2F7829%2Fdemon-slayer-kimetsu-no-yaiba&psig=AOvVaw3DIDxnKZz92hAYLSrKCsf-&ust=1764215273865000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCIiQ95f0jpEDFQAAAAAdAAAAABAE",
        "eps": "Eps 26",
        "rating": "8.7",
        "views": "89.4K views",
        "title": "Kimetsu no Yaiba"
      },
      {
        "image": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.simonandschuster.com%2Fbooks%2FJujutsu-Kaisen-The-Official-Anime-Guide-Season-1%2FGege-Akutami%2FJujutsu-Kaisen-The-Official-Anime-Guide-Season%2F9781974740819&psig=AOvVaw02rFKOpBpMbfHOj88xpSRr&ust=1764215249332000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCPi0y4v0jpEDFQAAAAAdAAAAABAJ",
        "eps": "Eps 24",
        "rating": "8.9",
        "views": "112K views",
        "title": "Jujutsu Kaisen"
      },
      {
        "image": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vidio.com%2Fpremier%2F2930%2Fattack-on-titan&psig=AOvVaw2JRWa84Ss7keGwtu6oc4dV&ust=1764215213713000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCNi28_rzjpEDFQAAAAAdAAAAABAZ",
        "eps": "Eps 75",
        "rating": "9.0",
        "views": "210K views",
        "title": "Attack on Titan"
      },
      {
        "image": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fm.21cineplex.com%2Fid%2Fmovies%2F25CMRA&psig=AOvVaw1TrJDKtUw4uM-ad3MV_D5d&ust=1764215183919000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCKij_-zzjpEDFQAAAAAdAAAAABAE",
        "eps": "Eps 12",
        "rating": "8.5",
        "views": "77K views",
        "title": "Chainsaw Man"
      },
      {
        "image": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.imdb.com%2Ftitle%2Ftt22248376%2F&psig=AOvVaw1BSZkvqIWL05t-uXXXblYy&ust=1764215156927000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCLChiuDzjpEDFQAAAAAdAAAAABAE",
        "eps": "Eps 28",
        "rating": "9.2",
        "views": "130K views",
        "title": "Frieren"
      },
      {
        "image": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.kapanlagi.com%2Fjepang%2Furutan-nonton-anime-overlord-beserta-sinopsis-lengkapnya-dari-serial-movie-84f71c.html&psig=AOvVaw2rG7X976FMMID-KdA9HqEI&ust=1764215098445000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCKDE38XzjpEDFQAAAAAdAAAAABAE",
        "eps": "Eps 13",
        "rating": "7.9",
        "views": "65K views",
        "title": "Overlord"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Subscribed Anime',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              const Text('Total (89)', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),

              const Text('Ongoing (1)', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 10),

              SizedBox(
                height: cardHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    AnimeCard(
                      image: 'https://i.ibb.co/3CG6W1f/solo.jpg',
                      eps: 'Eps 12',
                      rating: '9.1',
                      views: '102K views',
                      title: 'Solo Leveling',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text('Completed (88)', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 10),

              SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: completedList.length,
                  itemBuilder: (context, index) {
                    final anime = completedList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: AnimeCard(
                        image: anime["image"]!,
                        eps: anime["eps"]!,
                        rating: anime["rating"]!,
                        views: anime["views"]!,
                        title: anime["title"]!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
