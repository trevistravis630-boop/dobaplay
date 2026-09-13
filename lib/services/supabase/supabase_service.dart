import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseClient client =
      Supabase.instance.client;

  // Get tracks together with their artist and album information.
  static Future<List<Map<String, dynamic>>> getTracks() async {
    final response = await client
        .from('tracks')
        .select('''
          id,
          title,
          audio_url,
          cover_url,
          duration_seconds,
          genre,
          description,
          play_count,
          created_at,
          artists (
            id,
            name,
            image_url
          ),
          albums (
            id,
            title,
            cover_url
          )
        ''')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Get the most-played tracks.
  static Future<List<Map<String, dynamic>>> getFeaturedTracks() async {
    final response = await client
        .from('tracks')
        .select('''
          id,
          title,
          audio_url,
          cover_url,
          duration_seconds,
          genre,
          description,
          play_count,
          created_at,
          artists (
            id,
            name,
            image_url
          ),
          albums (
            id,
            title,
            cover_url
          )
        ''')
        .order('play_count', ascending: false)
        .limit(10);

    return List<Map<String, dynamic>>.from(response);
  }

  // Search tracks and artists.
  static Future<List<Map<String, dynamic>>> searchTracks(
    String query,
  ) async {
    final searchTerm = query.trim();

    if (searchTerm.isEmpty) {
      return [];
    }

    final trackResponse = await client
        .from('tracks')
        .select('''
          id,
          title,
          audio_url,
          cover_url,
          duration_seconds,
          genre,
          description,
          play_count,
          created_at,
          artists (
            id,
            name,
            image_url
          ),
          albums (
            id,
            title,
            cover_url
          )
        ''')
        .or(
          'title.ilike.%$searchTerm%,'
          'genre.ilike.%$searchTerm%,'
          'description.ilike.%$searchTerm%',
        )
        .order('created_at', ascending: false)
        .limit(30);

    final tracks =
        List<Map<String, dynamic>>.from(trackResponse);

    final artistResponse = await client
        .from('artists')
        .select('id, name, image_url')
        .ilike('name', '%$searchTerm%')
        .limit(20);

    final artists =
        List<Map<String, dynamic>>.from(artistResponse);

    if (artists.isNotEmpty) {
      final artistIds = artists
          .map((artist) => artist['id'])
          .where((id) => id != null)
          .toList();

      if (artistIds.isNotEmpty) {
        final artistTracksResponse = await client
            .from('tracks')
            .select('''
              id,
              title,
              audio_url,
              cover_url,
              duration_seconds,
              genre,
              description,
              play_count,
              created_at,
              artists (
                id,
                name,
                image_url
              ),
              albums (
                id,
                title,
                cover_url
              )
            ''')
            .inFilter('artist_id', artistIds)
            .order('created_at', ascending: false)
            .limit(30);

        final artistTracks =
            List<Map<String, dynamic>>.from(
          artistTracksResponse,
        );

        tracks.addAll(artistTracks);
      }
    }

    final uniqueTracks = <String, Map<String, dynamic>>{};

    for (final track in tracks) {
      final id = track['id']?.toString();

      if (id != null) {
        uniqueTracks[id] = track;
      }
    }

    return uniqueTracks.values.toList();
  }

  // Increase the play count for a track.
  static Future<void> incrementPlayCount(
    String trackId,
  ) async {
    final track = await client
        .from('tracks')
        .select('play_count')
        .eq('id', trackId)
        .single();

    final currentCount =
        (track['play_count'] ?? 0) as int;

    await client
        .from('tracks')
        .update({
          'play_count': currentCount + 1,
        })
        .eq('id', trackId);
  }
}