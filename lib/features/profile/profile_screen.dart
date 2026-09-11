import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROFILE',
                style: GoogleFonts.rubikWetPaint(
                  fontSize: 32,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 28),

              // Profile header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.divider,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppTheme.primary,
                      child: Text(
                        'D',
                        style: GoogleFonts.rubikWetPaint(
                          fontSize: 42,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Doba User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'YOUR MUSIC. YOUR CITY.',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(
                            color: AppTheme.primary,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('EDIT PROFILE'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'YOUR DOBAPLAY',
                style: GoogleFonts.rubikWetPaint(
                  fontSize: 20,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.favorite_border,
                title: 'Liked Songs',
                subtitle: 'Songs you love',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.queue_music,
                title: 'Your Playlists',
                subtitle: 'Manage your playlists',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.history,
                title: 'Recently Played',
                subtitle: 'Your listening history',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.download_outlined,
                title: 'Downloads',
                subtitle: 'Manage offline music',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              Text(
                'SETTINGS',
                style: GoogleFonts.rubikWetPaint(
                  fontSize: 20,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Manage notifications',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                subtitle: 'Dark mode',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About Dobaplay',
                subtitle: 'Music • Culture • Nairobi',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  'DOBAPLAY',
                  style: GoogleFonts.rubikWetPaint(
                    fontSize: 24,
                    color: AppTheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Center(
                child: Text(
                  'MUSIC • CULTURE • NAIROBI',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}