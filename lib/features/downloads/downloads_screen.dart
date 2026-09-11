import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Map<String, String>> songs = [
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

  final List<Map<String, String>> albums = [
    {
      'title': 'Nairobi After Dark',
      'artist': 'Dobaplay',
      'size': '42 MB',
    },
  ];

  final List<Map<String, String>> playlists = [
    {
      'title': 'My Offline Mix',
      'artist': 'Dobaplay Playlist',
      'size': '28 MB',
    },
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
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
            _buildStorage(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSongList(songs),
                  _buildSongList(albums),
                  _buildSongList(playlists),
                ],
              ),
            ),
            _buildManageButton(),
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
        10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'DOWNLOADS',
              style: GoogleFonts.rubikWetPaint(
                color: AppTheme.primary,
                fontSize: 31,
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

  Widget _buildStorage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        12,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(
                      alpha: 0.12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: AppTheme.primary,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline Storage',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '84 MB of 1 GB used',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '8%',
                  style: GoogleFonts.montserrat(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.08,
                minHeight: 5,
                backgroundColor: AppTheme.divider,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(
                  AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
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
          _tab('Songs', 0),
          _tab('Albums', 1),
          _tab('Playlists', 2),
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
          horizontal: 18,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(22),
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

  Widget _buildSongList(
    List<Map<String, String>> items,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        20,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return _buildDownloadItem(
          title: item['title'] ?? 'Unknown',
          artist: item['artist'] ?? 'Unknown Artist',
          size: item['size'] ?? '',
        );
      },
    );
  }

  Widget _buildDownloadItem({
    required String title,
    required String artist,
    required String size,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
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
            width: 59,
            height: 59,
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
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
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
                const SizedBox(height: 4),
                Text(
                  artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  size,
                  style: GoogleFonts.montserrat(
                    color: AppTheme.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppTheme.primary,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        5,
        20,
        15,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.cleaning_services_outlined,
            size: 18,
          ),
          label: Text(
            'MANAGE DOWNLOADS',
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            side: BorderSide(
              color: AppTheme.primary.withValues(alpha: 0.35),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.download_rounded,
              color: AppTheme.primary,
              size: 48,
            ),
            const SizedBox(height: 15),
            Text(
              'Nothing downloaded',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your offline music will appear here.',
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