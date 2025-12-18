import 'package:supabase_flutter/supabase_flutter.dart';

class LikeService {
  static final _supabase = Supabase.instance.client;

  static Stream<int> streamLikeCount({
    required String animeTitle,
    required int episodeNumber,
  }) {
    return _supabase
        .from('video_likes')
        .stream(primaryKey: ['id'])
        .map((rows) {
          final filtered = rows.where((r) {
            return r['anime_title'] == animeTitle &&
                r['episode_number'] == episodeNumber;
          }).toList();
          return filtered.length;
        });
  }

  static Future<bool> isLiked({
    required String animeTitle,
    required int episodeNumber,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final res = await _supabase
        .from('video_likes')
        .select('id')
        .eq('user_id', user.id)
        .eq('anime_title', animeTitle)
        .eq('episode_number', episodeNumber)
        .maybeSingle();

    return res != null;
  }

  static Future<void> toggleLike({
    required String animeTitle,
    required int episodeNumber,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final existing = await _supabase
        .from('video_likes')
        .select('id')
        .eq('user_id', user.id)
        .eq('anime_title', animeTitle)
        .eq('episode_number', episodeNumber)
        .maybeSingle();

    if (existing == null) {
      await _supabase.from('video_likes').insert({
        'user_id': user.id,
        'anime_title': animeTitle,
        'episode_number': episodeNumber,
      });
    } else {
      await _supabase
          .from('video_likes')
          .delete()
          .eq('id', existing['id']);
    }
  }
}