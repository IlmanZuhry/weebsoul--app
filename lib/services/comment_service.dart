import 'package:supabase_flutter/supabase_flutter.dart';

class CommentService {
  static final _supabase = Supabase.instance.client;

  /// Ambil komentar sekali (non-stream)
  static Future<List<Map<String, dynamic>>> getComments(
    String animeTitle,
    int episodeNumber,
  ) async {
    try {
      final response = await _supabase
          .from('comments')
          .select()
          .order('created_at', ascending: false);

      final rows = List<Map<String, dynamic>>.from(response ?? []);

      final filtered = rows.where((r) {
        final a = r['anime_title'];
        final e = r['episode_number'];
        return a == animeTitle &&
            (e == episodeNumber ||
                (e is String && int.tryParse(e) == episodeNumber));
      }).toList();

      return filtered;
    } catch (e) {
      print('❌ Error fetching comments: $e');
      return [];
    }
  }

  /// Tambah komentar
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
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('❌ Error adding comment: $e');
      return false;
    }
  }

  /// Stream komentar realtime
  static Stream<List<Map<String, dynamic>>> streamComments(
    String animeTitle,
    int episodeNumber,
  ) {
    return _supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .map((rows) {
          final cast = (rows as List).cast<dynamic>();
          final mapped =
              cast.map((r) => Map<String, dynamic>.from(r as Map)).toList();

          final filtered = mapped.where((r) {
            final a = r['anime_title'];
            final e = r['episode_number'];
            return a == animeTitle &&
                (e == episodeNumber ||
                    (e is String && int.tryParse(e) == episodeNumber));
          }).toList();

          filtered.sort((a, b) {
            final ta = DateTime.tryParse(a['created_at']?.toString() ?? '') ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final tb = DateTime.tryParse(b['created_at']?.toString() ?? '') ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return tb.compareTo(ta);
          });

          return filtered;
        });
  }

  /// Stream jumlah komentar realtime
  static Stream<int> streamCommentCount(
    String animeTitle,
    int episodeNumber,
  ) {
    return streamComments(animeTitle, episodeNumber).map((list) => list.length);
  }

  /// Hapus komentar
  static Future<bool> deleteComment(String commentId) async {
    try {
      await _supabase.from('comments').delete().eq('id', commentId);
      return true;
    } catch (e) {
      print('❌ Error deleting comment: $e');
      return false;
    }
  }
}
