import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../services/audio/audio_player_service.dart';
import '../../services/supabase/supabase_service.dart';
import '../player/now_playing_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _results = [];

  bool _isSearching = false;
  String? _error;

  final List<String> _trending = [
    'Sauti Sol',
    'Bensoul',
    'Nairobi',
    'Afrobeats',
    'Gengetone',
    'Khaligraph Jones',
    'Zuchu',
    'Tanzanian Music',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final value = query.trim();

    if (value.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final tracks = await SupabaseService.searchTracks(value);

      if (!mounted) return;

      setState(() {
        _results = tracks;
        _isSearching = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSearching = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _playTrack(Map<String, dynamic> track) async {
    final audioUrl = track['audio_url']?.toString();

    if (audioUrl == null || audioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio is not available for this track.'),
        ),
      );
      return;
    }

    final title =
        track['title']?.toString() ?? 'Unknown track';

    const artist = 'Migos';

    final coverUrl =
        track['cover_url']?.toString();

    try {
      await AudioPlayerService.play(audioUrl);

      if (!mounted) return;

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
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not play this track.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildHeader(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
            ),

            if (_searchController.text.trim().isEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  28,
                  20,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: _buildTrending(),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  30,
                  20,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: _buildCategories(),
                ),
              ),
            ] else ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  28,
                  20,
                  10,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'SEARCH RESULTS',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              _buildResults(),
            ],

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'SEARCH',
            style: GoogleFonts.rubikWetPaint(
              color: AppTheme.primary,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.16),
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _search,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: 'Search artists, songs, albums...',
          hintStyle: GoogleFonts.montserrat(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppTheme.textSecondary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _results = [];
                      _error = null;
                      _isSearching = false;
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondary,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTrending() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Trending',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 9,
          runSpacing: 10,
          children: _trending.map((tag) {
            return GestureDetector(
              onTap: () {
                _searchController.text = tag;
                _search(tag);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.montserrat(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = [
      (Icons.queue_music_rounded, 'Playlists'),
      (Icons.person_rounded, 'Artists'),
      (Icons.album_rounded, 'Albums'),
      (Icons.equalizer_rounded, 'Genres'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse by Category',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -8,
                    bottom: -8,
                    child: Icon(
                      category.$1,
                      size: 70,
                      color: AppTheme.primary.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          category.$1,
                          color: AppTheme.primary,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.$2,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_isSearching) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_error != null) {
      return SliverToBoxAdapter(
        child: _buildMessage(
          'Something went wrong.\nPlease try again.',
        ),
      );
    }

    if (_results.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildMessage(
          'No music found.\nTry another search.',
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildResultCard(_results[index]);
        },
        childCount: _results.length,
      ),
    );
  }

  Widget _buildResultCard(
    Map<String, dynamic> track,
  ) {
    final title =
        track['title']?.toString() ?? 'Unknown track';

    final coverUrl =
        track['cover_url']?.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      child: GestureDetector(
        onTap: () => _playTrack(track),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: coverUrl != null &&
                        coverUrl.isNotEmpty
                    ? Image.network(
                        coverUrl,
                        width: 58,
                        height: 58,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, error, stackTrace) {
                          return _artworkPlaceholder();
                        },
                      )
                    : _artworkPlaceholder(),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Migos',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _artworkPlaceholder() {
    return Container(
      width: 58,
      height: 58,
      color: AppTheme.surfaceLight,
      child: const Icon(
        Icons.music_note_rounded,
        color: AppTheme.primary,
        size: 25,
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: AppTheme.textSecondary,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}