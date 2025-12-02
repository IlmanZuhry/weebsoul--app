import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk mengelola video streaming dari Supabase Database
class VideoService {
  static final _supabase = Supabase.instance.client;

  /// Ambil URL video dari database berdasarkan anime title dan episode number
  /// 
  /// Returns: Video URL jika ditemukan, atau dummy URL jika tidak ada
  static Future<String> getVideoUrl(String animeTitle, int episodeNumber) async {
    try {
      // 🔍 DEBUG: Log query parameters
      print('🔍 Mencari video: "$animeTitle" Episode $episodeNumber');
      
      final response = await _supabase
          .from('videos')
          .select('video_url')
          .eq('anime_title', animeTitle)
          .eq('episode_number', episodeNumber)
          .maybeSingle(); // maybeSingle() returns null if not found

      if (response != null && response['video_url'] != null) {
        print('✅ Video ditemukan: ${response['video_url']}');
        return response['video_url'] as String;
      }

      // Fallback ke dummy video jika tidak ditemukan
      print('⚠️ Video tidak ditemukan untuk: "$animeTitle" Episode $episodeNumber');
      print('💡 Pastikan data sudah ada di database dengan anime_title yang sama persis!');
      return "https://samplelib.com/lib/preview/mp4/sample-5s.mp4";
    } catch (e) {
      print('❌ Error fetching video URL: $e');
      // Fallback ke dummy video jika error
      return "https://samplelib.com/lib/preview/mp4/sample-5s.mp4";
    }
  }

  /// Ambil semua video untuk anime tertentu
  /// 
  /// Berguna untuk pre-loading atau menampilkan daftar episode yang tersedia
  static Future<List<Map<String, dynamic>>> getAnimeVideos(String animeTitle) async {
    try {
      final response = await _supabase
          .from('videos')
          .select('episode_number, video_url')
          .eq('anime_title', animeTitle)
          .order('episode_number', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching anime videos: $e');
      return [];
    }
  }

  /// Cek apakah video tersedia untuk episode tertentu
  static Future<bool> isVideoAvailable(String animeTitle, int episodeNumber) async {
    try {
      final response = await _supabase
          .from('videos')
          .select('id')
          .eq('anime_title', animeTitle)
          .eq('episode_number', episodeNumber)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
