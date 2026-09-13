import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isLoading = true;
  String? _error;

  List<Map<String, dynamic>> _albums = [];
  List<Map<String, dynamic>> _artists = [];

  final List<Map<String, dynamic>> _playlists = [
    {
      'title': 'My Mix',
      'subtitle': '432 songs',
      'icon': Icons.favorite_rounded,
    },
    {
      'title': 'Nairobi Nights',
      'subtitle': '87 songs',
      'icon': Icons.nightlight_round,
    },
    {
      'title': 'Afro Vibes',
      'subtitle': '120 songs',
      'icon': Icons.music_note_rounded,
    },
    {
      'title': 'Kenyan Classics',
      'subtitle': '56 songs',
      'icon': Icons.album_rounded,
    },
    {
      'title': 'Workout Mode',
      'subtitle': '78 songs',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'title': 'Chill & Relax',
      'subtitle': '64 songs',
      'icon': Icons.spa_rounded,
    },
  ];

  final List<Map<String, dynamic>> _downloaded = [
    {
      'title': 'Bad and Boujee',
      'artist': 'Migos',
      'size': '6.8 MB',
    },
    {
      'title': 'Nairobi Nights',
      'artist': 'Kenyan Artist',
      'size': '7.2 MB',
    },
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 4,
      vsync: this,
    );

    _loadLibrary();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLibrary() async {
    try {
      final supabase = Supabase.instance.client;

      final albumsResponse = await supabase
          .from('albums')
          .select('''
            id,
            title,
            cover_url,
            artist_id,
            artists (
              id,
              name,
              image_url
            )
          ''')
          .order('title');

      final artistsResponse = await supabase
          .from('artists')
          .select('''
            id,
            name,
            image_url,
            bio
          ''')
          .order('name');

      if (!mounted) return;

      setState(() {
        _albums = List<Map<String, dynamic>>.from(
          albumsResponse,
        );

        _artists = List<Map<String, dynamic>>.from(
          artistsResponse,
        );

        _isLoading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),
              child: _buildHeader(),
            ),
            const SizedBox(height: 22),
            _buildTabs(),
            const SizedBox(height: 8),
            Expanded(
              child: _buildTabContent(),
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
            'YOUR LIBRARY',
            style: GoogleFonts.rubikWetPaint(
              color: AppTheme.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InkWell(
          onTap: _loadLibrary,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppTheme.primary.withValues(
            alpha: 0.16,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Playlists'),
          Tab(text: 'Albums'),
          Tab(text: 'Artists'),
          Tab(text: 'Downloaded'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildPlaylists(),
        _buildAlbums(),
        _buildArtists(),
        _buildDownloaded(),
      ],
    );
  }

  Widget _buildPlaylists() {
    return RefreshIndicator(
      onRefresh: _loadLibrary,
      color: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        itemCount: _playlists.length,
        separatorBuilder: (_, index) =>
            const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final playlist = _playlists[index];

          return _buildPlaylistCard(playlist);
        },
      ),
    );
  }

  Widget _buildPlaylistCard(
    Map<String, dynamic> playlist,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              playlist['icon'] as IconData,
              color: AppTheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  playlist['title'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  playlist['subtitle'].toString(),
                  style: GoogleFonts.montserrat(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildAlbums() {
    if (_albums.isEmpty) {
      return _buildEmptyState(
        Icons.album_rounded,
        'No albums yet',
        'Albums from Supabase will appear here.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLibrary,
      color: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        itemCount: _albums.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 18,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          return _buildAlbumCard(_albums[index]);
        },
      ),
    );
  }

  Widget _buildAlbumCard(
    Map<String, dynamic> album,
  ) {
    final title =
        album['title']?.toString() ?? 'Unknown Album';

    final coverUrl =
        album['cover_url']?.toString();

    final artistData = album['artists'];

    final artist = artistData is Map
        ? artistData['name']?.toString() ??
            'Unknown Artist'
        : 'Unknown Artist';

    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: coverUrl != null &&
                      coverUrl.isNotEmpty
                  ? Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, error, stackTrace) {
                        return _artworkPlaceholder();
                      },
                    )
                  : _artworkPlaceholder(),
            ),
          ),
          const SizedBox(height: 9),
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
    );
  }

  Widget _buildArtists() {
    if (_artists.isEmpty) {
      return _buildEmptyState(
        Icons.person_rounded,
        'No artists yet',
        'Artists from Supabase will appear here.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLibrary,
      color: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        itemCount: _artists.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 18,
          childAspectRatio: 0.86,
        ),
        itemBuilder: (context, index) {
          return _buildArtistCard(_artists[index]);
        },
      ),
    );
  }

  Widget _buildArtistCard(
    Map<String, dynamic> artist,
  ) {
    final name =
        artist['name']?.toString() ?? 'Unknown Artist';

    final imageUrl =
        artist['image_url']?.toString();

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 92,
                height: 92,
                child: imageUrl != null &&
                        imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, error, stackTrace) {
                          return _artistPlaceholder();
                        },
                      )
                    : _artistPlaceholder(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Artist',
              style: GoogleFonts.montserrat(
                color: AppTheme.textSecondary,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloaded() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      children: [
        _buildStorageCard(),
        const SizedBox(height: 22),
        Text(
          'Downloaded songs',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ..._downloaded.map(
          (song) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildDownloadedCard(song),
          ),
        ),
      ],
    );
  }

  Widget _buildStorageCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(
                    alpha: 0.12,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.storage_rounded,
                  color: AppTheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Offline Storage',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '84 MB / 1 GB',
                style: GoogleFonts.montserrat(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.08,
              minHeight: 7,
              backgroundColor:
                  Colors.white.withValues(alpha: 0.07),
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadedCard(
    Map<String, dynamic> song,
  ) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  song['title'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${song['artist']} • ${song['size']}',
                  style: GoogleFonts.montserrat(
                    color: AppTheme.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.primary,
            size: 21,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    IconData icon,
    String title,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: AppTheme.textSecondary,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: AppTheme.primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load your library',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your Supabase connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _loadLibrary,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _artworkPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withValues(alpha: 0.30),
            const Color(0xFF15151D),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.album_rounded,
          color: Colors.white.withValues(alpha: 0.75),
          size: 42,
        ),
      ),
    );
  }

  Widget _artistPlaceholder() {
    return Container(
      color: AppTheme.surfaceLight,
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: AppTheme.primary.withValues(
            alpha: 0.75,
          ),
          size: 42,
        ),
      ),
    );
  }
}