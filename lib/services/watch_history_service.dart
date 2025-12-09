import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk mengelola riwayat tontonan dari Supabase Database
class WatchHistoryService {
  static final _supabase = Supabase.instance.client;

  /// Simpan atau update riwayat tontonan
  static Future<bool> saveWatchHistory({
    required String animeTitle,
    required int episodeNumber,
    required int watchedDuration,
    required int totalDuration,
    required String imageUrl,
    required String episodeLabel,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('⚠️ User not logged in');
        return false;
      }

      // Upsert: insert jika belum ada, update jika sudah ada
      await _supabase.from('watch_history').upsert({
        'user_id': user.id,
        'anime_title': animeTitle,
        'episode_number': episodeNumber,
        'watched_duration': watchedDuration,
        'total_duration': totalDuration,
        'image_url': imageUrl,
        'anime_episode_label': episodeLabel,
        'last_watched_at': DateTime.now().toIso8601String(),
      });

      print('✅ Watch history saved: $animeTitle - Episode $episodeNumber');
      return true;
    } catch (e) {
      print('❌ Error saving watch history: $e');
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
      print('❌ Error updating progress: $e');
      return false;
    }
  }

  /// Get semua riwayat tontonan user (sorted by last watched)
  static Future<List<Map<String, dynamic>>> getWatchHistory() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('⚠️ User not logged in');
        return [];
      }

      final response = await _supabase
          .from('watch_history')
          .select()
          .eq('user_id', user.id)
          .order('last_watched_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching watch history: $e');
      return [];
    }
  }

  /// Get riwayat tontonan yang dikelompokkan berdasarkan waktu
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
        final difference = now.difference(lastWatched);

        if (difference.inHours < 24) {
          grouped['Baru Saja']!.add(item);
        } else if (difference.inDays < 7) {
          grouped['Minggu Ini']!.add(item);
        } else if (difference.inDays < 30) {
          grouped['Bulan Lalu']!.add(item);
        }
      }

      return grouped;
    } catch (e) {
      print('❌ Error grouping watch history: $e');
      return {
        'Baru Saja': [],
        'Minggu Ini': [],
        'Bulan Lalu': [],
      };
    }
  }

  /// Get progress untuk anime & episode tertentu
  static Future<Map<String, dynamic>?> getProgress({
    required String animeTitle,
    required int episodeNumber,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('watch_history')
          .select()
          .eq('user_id', user.id)
          .eq('anime_title', animeTitle)
          .eq('episode_number', episodeNumber)
          .maybeSingle();

      return response;
    } catch (e) {
      print('❌ Error getting progress: $e');
      return null;
    }
  }

  /// Delete riwayat tontonan tertentu
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

      print('✅ Watch history deleted');
      return true;
    } catch (e) {
      print('❌ Error deleting watch history: $e');
      return false;
    }
  }
}
