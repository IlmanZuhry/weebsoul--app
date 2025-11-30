import 'package:flutter/material.dart';
import 'package:weebsoul/data/anime_data.dart';
import 'package:weebsoul/models/anime_info.dart';
import 'package:weebsoul/screens/detail_page.dart';

class OngoingAnimePage extends StatefulWidget {
  const OngoingAnimePage({super.key});

  @override
  State<OngoingAnimePage> createState() => _OngoingAnimePageState();
}

class _OngoingAnimePageState extends State<OngoingAnimePage> {
  // 1. STATE UNTUK FILTER
  Map<String, String> selectedFilters = {
    "Genre": "All",
    "Status": "On Going",
    "Content Type": "All",
    "Type": "All",
    "Order": "Newest",
    "Color": "Any",
  };

  // 2. OPSI PILIHAN FILTER
  final Map<String, List<String>> filterOptions = {
    "Genre": ["All", "Action", "Adventure", "Fantasy", "Sports", "Romance", "Supernatural", "Comedy", "Sci-Fi", "Drama"],
    "Status": ["On Going", "Completed"],
    "Content Type": ["All", "TV", "Movie", "OVA"],
    "Type": ["All", "Sub", "Dub"],
    "Order": ["Newest", "Highest Rated", "A-Z"],
    "Color": ["Any", "Color", "B&W"],
  };

  // 3. LIST YANG DITAMPILKAN
  late List<AnimeInfo> displayedAnime;
  List<AnimeInfo> masterList = [];

  // 4. STATE UNTUK SEARCH
  bool _isSearching = false; // Menandai apakah mode pencarian aktif
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Gabungkan semua data
    masterList = [...ongoingAnime, ...completedAnime, ...mingguAnime];
    
    // Listener untuk pencarian real-time
    _searchController.addListener(() {
      _applyFilter();
    });

    _applyFilter();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 5. LOGIKA FILTER UTAMA + SEARCH
  void _applyFilter() {
    setState(() {
      Iterable<AnimeInfo> result = masterList;

      // --- A. FILTER STATUS ---
      if (selectedFilters["Status"] == "On Going") {
        result = result.where((anime) => ongoingAnime.contains(anime));
      } else if (selectedFilters["Status"] == "Completed") {
        result = result.where((anime) => completedAnime.contains(anime));
      }

      // --- B. FILTER GENRE ---
      if (selectedFilters["Genre"] != "All") {
        result = result.where((anime) {
           if (anime.genres.isNotEmpty) {
             return anime.genres.contains(selectedFilters["Genre"]);
           }
           return anime.genre == selectedFilters["Genre"];
        });
      }

      // --- C. LOGIKA SEARCH (BARU) ---
      String query = _searchController.text.toLowerCase();
      if (query.isNotEmpty) {
        result = result.where((anime) {
          return anime.title.toLowerCase().contains(query);
        });
      }

      // --- D. FILTER ORDER ---
      var resultList = result.toList();
      if (selectedFilters["Order"] == "Highest Rated") {
        resultList.sort((a, b) => b.rating.compareTo(a.rating)); 
      } else if (selectedFilters["Order"] == "A-Z") {
        resultList.sort((a, b) => a.title.compareTo(b.title)); 
      } 
      
      displayedAnime = resultList;
    });
  }

  // 6. TOGGLE SEARCH MODE
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Hapus teks jika search ditutup
        _applyFilter(); // Reset list
      }
    });
  }

  // 7. MEMBUKA MENU PILIHAN (BOTTOM SHEET)
  void _showSelectionPicker(String filterKey, IconData icon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select $filterKey",
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[800]),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: filterOptions[filterKey]!.map((option) {
                    bool isSelected = selectedFilters[filterKey] == option;
                    return ListTile(
                      leading: Icon(
                        icon, 
                        color: isSelected ? Colors.blueAccent : Colors.grey
                      ),
                      title: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Colors.blueAccent : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.blueAccent) : null,
                      onTap: () {
                        setState(() {
                          selectedFilters[filterKey] = option;
                        });
                        _applyFilter();
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_isSearching) {
              _toggleSearch(); // Jika sedang search, back button menutup search dulu
            } else {
              Navigator.pop(context);
            }
          },
        ),
        // === JUDUL BERUBAH JADI TEXTFIELD SAAT SEARCH AKTIF ===
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Cari judul anime...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              )
            : Text(
                selectedFilters["Status"] == "Completed" ? "Completed Anime" : "On Going Anime",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
        actions: [
          // === ICON SEARCH BERUBAH JADI CLOSE SAAT AKTIF ===
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sembunyikan tulisan "Filter" dan tombol grid saat sedang mencari agar lebih bersih (Opsional)
              // Tapi di sini saya biarkan tetap muncul agar user tetap bisa memfilter hasil pencarian
              const Text(
                "Filter",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFilterBtn("Genre", Icons.category),
                  _buildFilterBtn("Status", Icons.timelapse),
                  _buildFilterBtn("Content Type", Icons.movie_filter),
                  _buildFilterBtn("Type", Icons.subtitles),
                  _buildFilterBtn("Order", Icons.sort),
                  _buildFilterBtn("Color", Icons.palette),
                ],
              ),

              const SizedBox(height: 25),
              const Divider(color: Colors.white24),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${displayedAnime.length} Results",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Icon(Icons.grid_view, color: Colors.white70, size: 20),
                ],
              ),

              const SizedBox(height: 15),

              displayedAnime.isEmpty
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        //Tidak ditemukan saat search
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 50, color: Colors.white38),
                          const SizedBox(height: 10),
                          Text(
                            _isSearching 
                                ? "Tidak ditemukan: \"${_searchController.text}\"" 
                                : "Tidak ada anime ditemukan", 
                            style: const TextStyle(color: Colors.white38)
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      itemCount: displayedAnime.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) {
                        return _animeGridItem(displayedAnime[index]);
                      },
                    ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBtn(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _showSelectionPicker(label, icon),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedFilters[label] != "All" && selectedFilters[label] != "Any"
                ? Colors.blueAccent.withOpacity(0.5) 
                : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: selectedFilters[label] != "All" && selectedFilters[label] != "Any"
                  ? Colors.blueAccent 
                  : Colors.grey,
              size: 18
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                  Text(
                    selectedFilters[label]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _animeGridItem(AnimeInfo anime) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(anime: anime)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  anime.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    height: 140, color: Colors.grey[800], 
                    child: const Icon(Icons.broken_image, color: Colors.white24)
                  ),
                ),
              ),
              Positioned(
                top: 6, right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54, borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 10),
                      const SizedBox(width: 3),
                      Text(
                        anime.rating.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            anime.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}