import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weebsoul/models/anime_info.dart';

/// Service untuk mengelola anime favorit user dari Supabase Database
class FavoriteService {
  static final _supabase = Supabase.instance.client;

  /// Get semua favorit user yang sedang login
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('⚠️ User not logged in');
        return [];
      }

      final response = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching favorites: $e');
      return [];
    }
  }

  /// Add anime ke favorit
  static Future<bool> addFavorite(AnimeInfo anime) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('⚠️ User not logged in');
        return false;
      }

      await _supabase.from('favorites').insert({
        'user_id': user.id,
        'anime_title': anime.title,
        'anime_image_url': anime.imageUrl,
        'anime_rating': anime.rating,
        'anime_description': anime.description,
        'anime_genres': anime.genres.join(','), // Convert list to comma-separated string
        'anime_episodes': anime.episodes.join(','), // Convert list to comma-separated string
        'anime_views': anime.views,
        'anime_duration': anime.duration,
        'anime_episode': anime.episode,
      });

      print('✅ Added to favorites: ${anime.title}');
      return true;
    } catch (e) {
      print('❌ Error adding favorite: $e');
      return false;
    }
  }

  /// Remove anime dari favorit
  static Future<bool> removeFavorite(String animeTitle) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('⚠️ User not logged in');
        return false;
      }

      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('anime_title', animeTitle);

      print('✅ Removed from favorites: $animeTitle');
      return true;
    } catch (e) {
      print('❌ Error removing favorite: $e');
      return false;
    }
  }

  /// Cek apakah anime sudah difavoritkan
  static Future<bool> isFavorite(String animeTitle) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('anime_title', animeTitle)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('❌ Error checking favorite: $e');
      return false;
    }
  }
}
