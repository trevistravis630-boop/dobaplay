import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/theme/app_theme.dart';
import '../../features/player/now_playing_screen.dart';
import '../../services/audio/audio_player_service.dart';

class MiniPlayer extends StatelessWidget {
  final String title;
  final String artist;
  final String? coverUrl;

  const MiniPlayer({
    super.key,
    required this.title,
    required this.artist,
    this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: AudioPlayerService.instance.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        // Don't show the mini player until a track is loaded.
        if (state == null ||
            state.processingState == ProcessingState.idle) {
          return const SizedBox.shrink();
        }

        final isPlaying = state.playing;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NowPlayingScreen(
                  title: title,
                  artist: artist,
                  coverUrl: coverUrl,
                ),
              ),
            );
          },
          child: Container(
            height: 68,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 15,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),

                // Artwork
                ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: coverUrl != null && coverUrl!.isNotEmpty
                      ? Image.network(
                          coverUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, error, stackTrace) {
                            return _placeholderArtwork();
                          },
                        )
                      : _placeholderArtwork(),
                ),

                const SizedBox(width: 12),

                // Song information
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                // Play / pause
                IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await AudioPlayerService.pause();
                    } else {
                      await AudioPlayerService.instance.play();
                    }
                  },
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                ),

                // Stop
                IconButton(
                  onPressed: () async {
                    await AudioPlayerService.stop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _placeholderArtwork() {
    return Container(
      width: 50,
      height: 50,
      color: AppTheme.surfaceLight,
      child: const Icon(
        Icons.music_note_rounded,
        color: AppTheme.primary,
        size: 24,
      ),
    );
  }
}