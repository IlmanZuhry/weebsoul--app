import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk mengelola komentar dari Supabase Database
class CommentService {
  static final _supabase = Supabase.instance.client;

  /// Get comments untuk anime & episode tertentu
  static Future<List<Map<String, dynamic>>> getComments(
    String animeTitle,
    int episodeNumber,
  ) async {
    try {
      final response = await _supabase
          .from('comments')
          .select()
          .eq('anime_title', animeTitle)
          .eq('episode_number', episodeNumber)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching comments: $e');
      return [];
    }
  }

  /// Add new comment
  static Future<bool> addComment({
    required String animeTitle,
    required int episodeNumber,
    required String commentText,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('⚠️ User not logged in');
        return false;
      }

      await _supabase.from('comments').insert({
        'anime_title': animeTitle,
        'episode_number': episodeNumber,
        'user_id': user.id,
        'user_name': user.userMetadata?['name'] ?? 
                     user.email?.split('@')[0] ?? 
                     'Anonymous',
        'user_avatar': user.userMetadata?['avatar_url'],
        'comment_text': commentText,
      });

      print('✅ Comment added successfully');
      return true;
    } catch (e) {
      print('❌ Error adding comment: $e');
      return false;
    }
  }

  /// Delete comment (user can only delete their own)
  static Future<bool> deleteComment(String commentId) async {
    try {
      await _supabase
          .from('comments')
          .delete()
          .eq('id', commentId);
      
      print('✅ Comment deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting comment: $e');
      return false;
    }
  }
}
