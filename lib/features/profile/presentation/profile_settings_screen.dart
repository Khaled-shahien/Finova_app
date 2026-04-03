import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';

/// Profile and settings page.
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool get _isDarkMode => AppThemeController.instance.mode == ThemeMode.dark;

  static const String _topAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDoFkozuSaFf1y1ik-XaZQW4u2D9xTpEf9VA7BLiZwsxFi045pLIake1cIqpAsOnPjAdEAaEDOnfCCXTusXdt92_xWYX1GBdF60bkB5Y0NuEJSCWaMb6phTWdBnYsKic3UpSo2o6vcFJTkppxum9rsJFR6AefZM3NaA8WebOibDS6cYRbmvOM3lkBbn2nsIX4kAS8YWrTfjBLsJaJ-TRr22nVSsdmm547Z8qm0D_mDDoVur4iK3PpJaNBvXKTBnBRLJxBx3gnGA6KA';
  static const String _heroAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCBD-J1ZTMlcymsitHACHNpve0_O4wQ7U8kLuysDuJHpDPEAJBR2nzvKRx6wS_lMR4wPc7B0B0ELaapbtwD4m6JGjgx4iCBW4gQdHT7LT7k3cxAbDtImWl1RQBFzYUDY_c0JQGxvpwgm3hmwOTh0KShyoeZFwVDPOgH1aKJXUU8bqDBxIhMM0i_VzhfPF86BsPjV9ooHXtn9PhOz8Q_AdQtZR-Q5ldts0uBX9l-u3JuHoYvfuyH6FO4I7oXg3NpY06zOrYRCHc2md8';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 34),
        children: [
          _buildTopBar(),
          const SizedBox(height: 36),
          _buildHero(),
          const SizedBox(height: 42),
          _buildSubscriptionCard(),
          const SizedBox(height: 34),
          _buildSectionTitle('PREFERENCES'),
          const SizedBox(height: 12),
          _buildSettingRow(
            icon: Icons.payments_outlined,
            title: 'Currency Selection',
            subtitle: 'USD - United States Dollar',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildDarkModeRow(),
          const SizedBox(height: 10),
          _buildSettingRow(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications',
            subtitle: 'Alerts, News, and Weekly Reports',
            onTap: () {},
          ),
          const SizedBox(height: 34),
          _buildSectionTitle('SUPPORT & PRIVACY'),
          const SizedBox(height: 12),
          _buildSettingRow(
            icon: Icons.contact_support_outlined,
            title: 'Help & Support',
            subtitle: '24/7 concierge assistance',
            onTap: () {},
          ),
          const SizedBox(height: 14),
          _buildLogoutRow(),
          const SizedBox(height: 34),
          Text(
            'V2.4.0 • THE FINANCIAL ATELIER',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.outline,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(RouteNames.home);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 2),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.network(
              _topAvatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, color: AppColors.primary);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'The Financial Atelier',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 166,
              height: 166,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surfaceContainerLowest,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  _heroAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: AppColors.primaryFixed,
                      child: Icon(Icons.person, size: 68),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 6,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: AppColors.onPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Julian Thorne',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Premium Curator Membership',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      height: 222,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryContainer, AppColors.primary],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUBSCRIPTION',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.75),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Atelier Gold Tier',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'Next billing date: Oct 24, 2023',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.72),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLowest,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                child: const Text('Upgrade Plan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.onSurfaceVariant,
          letterSpacing: 2.2,
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dark_mode_outlined,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Mode',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  'Match system preferences',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                AppThemeController.instance.setDarkMode(value);
              });
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutRow() {
    return Material(
      color: AppColors.tertiaryContainer.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: _logout,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: AppColors.tertiary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Sign out of this device',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.tertiary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await AuthService.instance.signOut();
    if (!mounted) {
      return;
    }
    context.go(RouteNames.auth);
  }
}
