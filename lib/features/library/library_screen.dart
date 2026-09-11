import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Map<String, String>> playlists = [
    {
      'title': 'My Mix',
      'subtitle': '432 songs',
    },
    {
      'title': 'Nairobi Nights',
      'subtitle': '87 songs',
    },
    {
      'title': 'Afro Vibes',
      'subtitle': '120 songs',
    },
    {
      'title': 'Kenyan Classics',
      'subtitle': '56 songs',
    },
    {
      'title': 'Workout Mode',
      'subtitle': '78 songs',
    },
    {
      'title': 'Chill & Relax',
      'subtitle': '64 songs',
    },
  ];

  final List<Map<String, String>> albums = [
    {
      'title': 'Nairobi Nights',
      'subtitle': 'Sauti Sol',
    },
    {
      'title': 'Mwanamke',
      'subtitle': 'Bensoul',
    },
    {
      'title': 'Tingiza',
      'subtitle': 'Khaligraph Jones',
    },
    {
      'title': 'Eka',
      'subtitle': 'Femi One',
    },
  ];

  final List<Map<String, String>> artists = [
    {
      'title': 'Sauti Sol',
      'subtitle': 'Kenyan Artist',
    },
    {
      'title': 'Bensoul',
      'subtitle': 'Kenyan Artist',
    },
    {
      'title': 'Khaligraph Jones',
      'subtitle': 'Kenyan Artist',
    },
    {
      'title': 'Femi One',
      'subtitle': 'Kenyan Artist',
    },
  ];

  final List<Map<String, String>> downloaded = [
    {
      'title': 'Bad and Boujee',
      'subtitle': 'Migos',
    },
    {
      'title': 'Nairobi Nights',
      'subtitle': 'Sauti Sol',
    },
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 4,
      vsync: this,
    );

    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPlaylistList(),
                  _buildGrid(albums),
                  _buildGrid(artists),
                  _buildDownloadedList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        16,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'LIBRARY',
              style: GoogleFonts.rubikWetPaint(
                color: AppTheme.primary,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _iconButton(
            Icons.settings_outlined,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 48,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection: Axis.horizontal,
        children: [
          _tab('Playlists', 0),
          _tab('Albums', 1),
          _tab('Artists', 2),
          _tab('Downloaded', 3),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    final selected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 9),
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? AppTheme.primary
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            color: selected
                ? Colors.white
                : AppTheme.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final item = playlists[index];

        return _buildListTile(
          title: item['title']!,
          subtitle: item['subtitle']!,
          icon: _playlistIcon(index),
          trailing: const Icon(
            Icons.more_vert_rounded,
            color: AppTheme.textSecondary,
          ),
        );
      },
    );
  }

  Widget _buildDownloadedList() {
    if (downloaded.isEmpty) {
      return _buildEmptyState(
        Icons.download_rounded,
        'No downloads yet',
        'Your downloaded music will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: downloaded.length,
      itemBuilder: (context, index) {
        final item = downloaded[index];

        return _buildListTile(
          title: item['title']!,
          subtitle: item['subtitle']!,
          icon: Icons.music_note_rounded,
          trailing: const Icon(
            Icons.check_rounded,
            color: AppTheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildGrid(
    List<Map<String, String>> items,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return _buildGridCard(
          item['title']!,
          item['subtitle']!,
          index,
        );
      },
    );
  }

  Widget _buildGridCard(
    String title,
    String subtitle,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primary.withValues(alpha: 0.28),
                  AppTheme.surface,
                  const Color(0xFF101016),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -12,
                  bottom: -12,
                  child: Icon(
                    index.isEven
                        ? Icons.album_rounded
                        : Icons.person_rounded,
                    size: 90,
                    color: AppTheme.primary.withValues(
                      alpha: 0.08,
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    index.isEven
                        ? Icons.album_rounded
                        : Icons.person_rounded,
                    color: AppTheme.primary,
                    size: 42,
                  ),
                ),
              ],
            ),
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
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            color: AppTheme.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primary.withValues(alpha: 0.32),
                  const Color(0xFF15151D),
                ],
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.85),
              size: 27,
            ),
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
                const SizedBox(height: 5),
                Text(
                  subtitle,
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
          trailing,
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.primary,
              size: 50,
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
            const SizedBox(height: 7),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _playlistIcon(int index) {
    switch (index) {
      case 0:
        return Icons.favorite_rounded;
      case 1:
        return Icons.nightlife_rounded;
      case 2:
        return Icons.music_note_rounded;
      case 3:
        return Icons.library_music_rounded;
      case 4:
        return Icons.fitness_center_rounded;
      default:
        return Icons.self_improvement_rounded;
    }
  }

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 21,
        ),
      ),
    );
  }
}