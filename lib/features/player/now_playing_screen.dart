import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../services/audio/audio_player_service.dart';

class NowPlayingScreen extends StatefulWidget {
  final String title;
  final String artist;
  final String? coverUrl;

  const NowPlayingScreen({
    super.key,
    required this.title,
    required this.artist,
    this.coverUrl,
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool isPlaying = false;
  bool isLiked = false;
  bool isShuffle = false;
  bool isRepeat = false;

  double progress = 0.0;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<bool>? _playingSubscription;

  @override
  void initState() {
    super.initState();

    isPlaying = AudioPlayerService.instance.playing;

    _positionSubscription =
        AudioPlayerService.instance.positionStream.listen((position) {
      final duration = AudioPlayerService.instance.duration;

      if (!mounted || duration == null || duration.inMilliseconds <= 0) {
        return;
      }

      setState(() {
        progress =
            position.inMilliseconds / duration.inMilliseconds;
      });
    });

    _playingSubscription =
        AudioPlayerService.instance.playingStream.listen((playing) {
      if (mounted) {
        setState(() {
          isPlaying = playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playingSubscription?.cancel();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (AudioPlayerService.instance.playing) {
      await AudioPlayerService.pause();
    } else {
      await AudioPlayerService.instance.play();
    }
  }

  Future<void> _seek(double value) async {
    final duration = AudioPlayerService.instance.duration;

    if (duration == null) return;

    final position = duration * value;
    await AudioPlayerService.instance.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            final artworkSize =
                (height * 0.48).clamp(250.0, 390.0);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  _buildTopBar(),

                  SizedBox(height: height > 700 ? 18 : 8),

                  // Artwork
                  _buildArtwork(artworkSize),

                  SizedBox(height: height > 700 ? 20 : 14),

                  // Song information
                  _buildSongInfo(),

                  SizedBox(height: height > 700 ? 14 : 8),

                  // Like button
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      icon: Icon(
                        isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isLiked
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                        size: 27,
                      ),
                    ),
                  ),

                  // Progress
                  _buildProgress(),

                  SizedBox(height: height > 700 ? 12 : 5),

                  // Player controls
                  _buildControls(),

                  SizedBox(height: height > 700 ? 22 : 12),

                  // Audio quality
                  _buildAudioQuality(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 30,
          ),
          color: Colors.white,
        ),
        Expanded(
          child: Center(
            child: Text(
              'NOW PLAYING',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.queue_music_rounded,
            size: 24,
          ),
          color: AppTheme.textSecondary,
        ),
      ],
    );
  }

  Widget _buildArtwork(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: widget.coverUrl != null &&
              widget.coverUrl!.isNotEmpty
          ? Image.network(
              widget.coverUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildArtworkPlaceholder(size);
              },
            )
          : _buildArtworkPlaceholder(size),
    );
  }

  Widget _buildArtworkPlaceholder(double size) {
    return Container(
      color: AppTheme.surface,
      child: Center(
        child: Icon(
          Icons.music_note_rounded,
          color: AppTheme.primary,
          size: size * 0.22,
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.artist,
            style: GoogleFonts.montserrat(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primary,
            inactiveTrackColor: AppTheme.divider,
            thumbColor: AppTheme.primary,
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 14,
            ),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: _seek,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<Duration>(
                stream: AudioPlayerService.instance.positionStream,
                builder: (context, snapshot) {
                  return Text(
                    _formatDuration(
                      snapshot.data ?? Duration.zero,
                    ),
                    style: GoogleFonts.montserrat(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  );
                },
              ),
              StreamBuilder<Duration?>(
                stream: AudioPlayerService.instance.durationStream,
                builder: (context, snapshot) {
                  return Text(
                    _formatDuration(
                      snapshot.data ?? Duration.zero,
                    ),
                    style: GoogleFonts.montserrat(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              isShuffle = !isShuffle;
            });
          },
          icon: Icon(
            Icons.shuffle_rounded,
            size: 22,
            color: isShuffle
                ? AppTheme.primary
                : AppTheme.textSecondary,
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.skip_previous_rounded,
            size: 36,
          ),
          color: Colors.white,
        ),

        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.32),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.skip_next_rounded,
            size: 36,
          ),
          color: Colors.white,
        ),

        IconButton(
          onPressed: () {
            setState(() {
              isRepeat = !isRepeat;
            });
          },
          icon: Icon(
            Icons.repeat_rounded,
            size: 22,
            color: isRepeat
                ? AppTheme.primary
                : AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAudioQuality() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.graphic_eq_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Audio Quality',
                style: GoogleFonts.montserrat(
                  color: AppTheme.textSecondary,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'High',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}