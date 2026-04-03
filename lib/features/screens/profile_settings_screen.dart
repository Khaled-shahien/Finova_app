import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/route_names.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_bar.dart';

/// Profile and settings page.
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool get _isDarkMode => AppThemeController.instance.mode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EditorialAppBar(title: 'Profile'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primaryFixed,
            child: const Icon(Icons.person, size: 42, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            AuthService.instance.currentUser?.email ?? 'Guest User',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                AppThemeController.instance.setDarkMode(value);
              });
            },
            title: const Text('Dark mode'),
            subtitle: const Text('Switch between light and dark appearance'),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            subtitle: const Text('Sign out from your account'),
            tileColor: AppColors.tertiaryContainer.withValues(alpha: 0.14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            onTap: _logout,
          ),
        ],
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
