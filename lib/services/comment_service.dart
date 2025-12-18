import 'package:supabase_flutter/supabase_flutter.dart';

class CommentService {
  static final _supabase = Supabase.instance.client;

  static Stream<List<Map<String, dynamic>>> streamComments(
    String animeTitle,
    int episodeNumber,
  ) {
    return _supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((maps) => maps
            .where((m) =>
                m['anime_title'] == animeTitle &&
                m['episode_number'] == episodeNumber)
            .toList());
  }

  static Stream<int> streamCommentCount(
    String animeTitle,
    int episodeNumber,
  ) {
    return _supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .map((maps) => maps
            .where((m) =>
                m['anime_title'] == animeTitle &&
                m['episode_number'] == episodeNumber)
            .length);
  }

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