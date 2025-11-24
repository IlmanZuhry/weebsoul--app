import 'package:flutter/material.dart';
import 'package:weebsoul/widgets/custom_navbar.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBanner = 0;
  int currentBottomIndex = 0;

  final List<String> banners = [
    "https://awsimages.detik.net.id/community/media/visual/2025/03/09/one-punch-man-season-3-1741505097754.jpeg?w=700&q=90",
    "https://www.nme.com/wp-content/uploads/2025/04/Dandadan-season-2-main.jpg",
    "https://anithreadz-bucket.s3.ap-southeast-1.amazonaws.com/d1653d57-0eea-4587-a14d-c4974f016bf4-My%20Dress%20Up%20Darling%20Season%202%20Release%20&%20What%20You%20Need%20to%20Know-featured-image.jpg",
  ];

  final List<String> bannerTitles = [
    "One Punch Man\nSeason 3",
    "Dandadan\nSeason 2",
    "Sono Bisque Doll\nSeason 2",
  ];

  final List<String> bannerRatings = [
    "5.57",
    "8.47",
    "8.22",
  ]; // ← rating banner

  late PageController _pageController;
  final int initialPage = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
    currentBanner = initialPage % banners.length;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            "https://cdn.dribbble.com/userupload/17507007/file/original-d70a169a94153ac2b0f60a8cccb59651.png?resize=400x0",
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Rizky Galon",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications, color: Colors.white),
                  ],
                ),

                const SizedBox(height: 20),

                // SEARCH
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Cari Anime di sini",
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BANNER + GRADIENT + RATING
                SizedBox(
                  height: 260,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          banners[currentBanner],
                          fit: BoxFit.cover,
                        ),
                      ),

                      // GRADIENT ATAS
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.80),
                                Colors.black.withValues(alpha: 0.20),
                                Colors.black.withValues(alpha: 0.85),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // GRADIENT BAWAH
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 90,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xFF1E1E1E)],
                            ),
                          ),
                        ),
                      ),

                      // PAGEVIEW
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 160,
                            child: Listener(
                              onPointerSignal: (_) {},
                              child: PageView.builder(
                                controller: _pageController,
                                physics: const ClampingScrollPhysics(),
                                onPageChanged: (index) {
                                  setState(() {
                                    currentBanner = index % banners.length;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final realIndex = index % banners.length;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      fit: StackFit
                                          .expand, // 🔥 INI YANG PERBAIKI BUG
                                      children: [
                                        Image.network(
                                          banners[realIndex],
                                          fit: BoxFit
                                              .cover, // 🔥 WAJIB supaya gambar tetap persegi panjang
                                        ),

                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: ratingBadge(
                                            bannerRatings[realIndex],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // DOT INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (idx) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentBanner == idx ? 10 : 6,
                      height: currentBanner == idx ? 10 : 6,
                      decoration: BoxDecoration(
                        color: currentBanner == idx
                            ? Colors.white
                            : Colors.white30,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    bannerTitles[currentBanner],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ================= TERAKHIR DITONTON =================
                const Text(
                  "Terakhir Ditonton",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                lastWatchedCard(
                  title: "Chanto Suenai Kyuuetsuki-chan",
                  img:
                      "https://otakotaku.com/asset/img/anime/2025/09/chanto-suenai-kyuuketsuki-chan-68bac1f9b9363p.jpg",
                  episode: "Episode 4",
                  status: "On Going",
                  rating: "6.71",
                ),

                const SizedBox(height: 25),

                // ================= ONGOING =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "On Going Anime",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),

                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.58, // tweak kalau mau lebih tinggi/rendah
                  children: [
                    animeGridItem(
                      img:
                          "https://awsimages.detik.net.id/community/media/visual/2025/09/02/serial-anime-spy-x-family-season-3-1756791886541.webp?w=1200",
                      title: "Spy x Family Season 3",
                      rating: "8.19",
                    ),
                    animeGridItem(
                      img:
                          "https://otakotaku.com/asset/img/anime/2025/09/kao-ni-denai-kashiwada-san-68bc27a6e3df4p.jpg",
                      title: "Kao ni Denai",
                      rating: "6.74",
                    ),
                    animeGridItem(
                      img:
                          "https://i0.wp.com/anievo.id/wp-content/uploads/2025/08/weoifu.webp?ssl=1",
                      title: "Tomodachi no Imouto",
                      rating: "6.44",
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ================= COMPLETED =================
                const Text(
                  "Completed Anime",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.58,
                  children: [
                    animeGridItem(
                      img:
                          "https://conime.id/images/anime/kaoru-hana-official-visual.webp",
                      title: "Kaoru Hana wa Rin",
                      rating: "8.66",
                    ),
                    animeGridItem(
                      img:
                          "https://awsimages.detik.net.id/community/media/visual/2025/06/02/poster-anime-kaiju-no8-season-2-1748866050954.jpeg?w=1200",
                      title: "Kaijuu 8-gou Season 2",
                      rating: "7.80",
                    ),
                    animeGridItem(
                      img:
                          "https://a.storyblok.com/f/178900/1080x1350/73f019de0e/sakamoto-days-part-2-key-visual.jpg/m/filters:quality(95)format(webp)",
                      title: "Sakamoto Days Part 2",
                      rating: "7.92",
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // LOGO BULAT
                      ClipOval(
                        child: Image.asset(
                          "assets/logo.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 6),

                      // TEXT LOGO
                      const Text(
                        "Weebsoul",
                        style: TextStyle(
                          fontFamily: "Orbitron",
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // ⭐ UNIVERSAL BADGE WIDGET (bisa dipakai di mana saja)
  Widget ratingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.yellow, size: 14),
          const SizedBox(width: 3),
          Text(
            rating,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  Widget animeCard({
    required String title,
    required String rating,
    required String img,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  img,
                  width: 120,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

              // ⭐ RATING
              Positioned(top: 6, right: 6, child: ratingBadge(rating)),
            ],
          ),

          const SizedBox(height: 6),

          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  Widget lastWatchedCard({
    required String title,
    required String img,
    required String episode,
    required String status,
    required String rating,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                img,
                width: 90,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(top: 6, right: 6, child: ratingBadge(rating)),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.6),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                episode,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                status,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget animeGridItem({
    required String img,
    required String title,
    required String rating,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                img,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // ⭐ RATING
            Positioned(top: 6, right: 6, child: ratingBadge(rating)),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
