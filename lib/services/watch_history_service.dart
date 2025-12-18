import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk mengelola riwayat tontonan dari Supabase Database
class WatchHistoryService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Simpan / update progress tontonan
  static Future<bool> saveProgress({
    required String animeTitle,
    required int episodeNumber,
    required int watchedDuration,
    required int totalDuration,
    required String imageUrl,
    required String episodeLabel,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('watch_history').upsert({
        'user_id': user.id,
        'anime_title': animeTitle, // ✅ FIX FINAL
        'episode_number': episodeNumber,
        'watched_duration': watchedDuration,
        'total_duration': totalDuration,
        'image_url': imageUrl,
        'anime_episode_label': episodeLabel,
        'last_watched_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('❌ saveProgress error: $e');
      return false;
    }
  }

  /// Update progress tontonan
  static Future<bool> updateProgress({
    required String animeTitle,
    required int episodeNumber,
    required int watchedDuration,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase
          .from('watch_history')
          .update({
            'watched_duration': watchedDuration,
            'last_watched_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id)
          .eq('anime_title', animeTitle)
          .eq('episode_number', episodeNumber);

      return true;
    } catch (e) {
      print('❌ updateProgress error: $e');
      return false;
    }
  }

  /// Get progress episode tertentu (UNTUK RESUME)
  static Future<Map<String, dynamic>?> getProgress({
    required String animeTitle,
    required int episodeNumber,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      return await _supabase
          .from('watch_history')
          .select()
          .eq('user_id', user.id)
          .eq('anime_title', animeTitle)
          .eq('episode_number', episodeNumber)
          .maybeSingle();
    } catch (e) {
      print('❌ getProgress error: $e');
      return null;
    }
  }

  /// Get semua riwayat tontonan
  static Future<List<Map<String, dynamic>>> getWatchHistory() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase
          .from('watch_history')
          .select()
          .eq('user_id', user.id)
          .order('last_watched_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ getWatchHistory error: $e');
      return [];
    }
  }

  /// Get riwayat tontonan dikelompokkan (RIWAYAT PAGE)
  static Future<Map<String, List<Map<String, dynamic>>>> getWatchHistoryGrouped() async {
    try {
      final history = await getWatchHistory();
      final now = DateTime.now();

      final Map<String, List<Map<String, dynamic>>> grouped = {
        'Baru Saja': [],
        'Minggu Ini': [],
        'Bulan Lalu': [],
      };

      for (var item in history) {
        final lastWatched = DateTime.parse(item['last_watched_at']);
        final diff = now.difference(lastWatched);

        if (diff.inHours < 24) {
          grouped['Baru Saja']!.add(item);
        } else if (diff.inDays < 7) {
          grouped['Minggu Ini']!.add(item);
        } else if (diff.inDays < 30) {
          grouped['Bulan Lalu']!.add(item);
        }
      }

      return grouped;
    } catch (e) {
      print('❌ getWatchHistoryGrouped error: $e');
      return {
        'Baru Saja': [],
        'Minggu Ini': [],
        'Bulan Lalu': [],
      };
    }
  }

  /// Hapus riwayat tontonan
  static Future<bool> deleteWatchHistory({
    required String animeTitle,
    required int episodeNumber,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase
          .from('watch_history')
          .delete()
          .eq('user_id', user.id)
          .eq('anime_title', animeTitle)
          .eq('episode_number', episodeNumber);

      return true;
    } catch (e) {
      print('❌ deleteWatchHistory error: $e');
      return false;
    }
  }
}
