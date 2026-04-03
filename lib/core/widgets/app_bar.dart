import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../theme/app_theme.dart';

/// A customizable editorial-style app bar
class EditorialAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showProfile;
  final String? profileImage;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLeadingTap;

  const EditorialAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.showProfile = false,
    this.profileImage,
    this.onProfileTap,
    this.onLeadingTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Leading section
          if (leading != null)
            leading!
          else if (showProfile)
            GestureDetector(
              onTap:
                  onProfileTap ??
                  () {
                    context.go(RouteNames.profile);
                  },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: profileImage != null && profileImage!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, color: AppColors.primary);
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(Icons.person, color: AppColors.primary),
              ),
            )
          else
            IconButton(
              onPressed:
                  onLeadingTap ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                      return;
                    }
                    context.go(RouteNames.home);
                  },
              icon: const Icon(Icons.arrow_back),
              color: AppColors.onSurface,
            ),
          // Title (if provided)
          if (title != null) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          // Actions or profile
          if (actions != null)
            ...actions!
          else if (!showProfile)
            IconButton(
              onPressed: () {
                // Notifications
              },
              icon: const Icon(Icons.notifications_outlined),
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}
