import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseClient client = Supabase.instance.client;

  // Get all tracks
  static Future<List<Map<String, dynamic>>> getTracks() async {
    final response = await client
        .from('tracks')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Get featured/latest tracks
  static Future<List<Map<String, dynamic>>> getFeaturedTracks() async {
    final response = await client
        .from('tracks')
        .select()
        .order('play_count', ascending: false)
        .limit(10);

    return List<Map<String, dynamic>>.from(response);
  }

  // Search tracks
  static Future<List<Map<String, dynamic>>> searchTracks(
    String query,
  ) async {
    final response = await client
        .from('tracks')
        .select()
        .ilike('title', '%$query%')
        .limit(30);

    return List<Map<String, dynamic>>.from(response);
  }

  // Increase play count
  static Future<void> incrementPlayCount(String trackId) async {
    final track = await client
        .from('tracks')
        .select('play_count')
        .eq('id', trackId)
        .single();

    final currentCount = (track['play_count'] ?? 0) as int;

    await client
        .from('tracks')
        .update({'play_count': currentCount + 1})
        .eq('id', trackId);
  }
}