import 'package:flutter/material.dart';
import 'package:jelzy/widgets/app_icon.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/jellyfin_public_user.dart';
import '../../theme/mono_tokens.dart';
import '../../i18n/strings.g.dart';
import '../../widgets/optimized_image.dart' show blurArtwork;

class UserAvatarWidget extends StatelessWidget {
  final JellyfinPublicUser user;
  final double size;
  final bool showIndicators;
  final bool useTextLabels;
  final VoidCallback? onTap;

  /// Base URL needed to build the avatar image URL.
  final String? serverBaseUrl;

  const UserAvatarWidget({
    super.key,
    required this.user,
    this.size = 40,
    this.showIndicators = true,
    this.useTextLabels = false,
    this.onTap,
    this.serverBaseUrl,
  });

  Widget _buildPlaceholderAvatar(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, shape: BoxShape.circle),
      child: AppIcon(Symbols.person_rounded, fill: 1, size: size * 0.6, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildAvatar(BuildContext context, ThemeData theme) {
    final imageUrl = serverBaseUrl != null ? user.imageUrl(serverBaseUrl!) : '';
    final hasImage = imageUrl.isNotEmpty;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          ClipOval(
            child: hasImage
                ? blurArtwork(
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => _buildPlaceholderAvatar(theme),
                      errorWidget: (ctx, url, error) => _buildPlaceholderAvatar(theme),
                    ),
                  )
                : _buildPlaceholderAvatar(theme),
          ),
          // Password indicator badge
          if (showIndicators && user.hasPassword && !useTextLabels)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.surface, width: 1),
                ),
                child: AppIcon(Symbols.lock_rounded, fill: 1, size: size * 0.2, color: theme.colorScheme.onSecondary),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildTextLabels(BuildContext context, ThemeData theme) {
    if (!useTextLabels || !showIndicators) return [];
    if (!user.hasPassword) return [];
    return [
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(tokens(context).radiusSm),
        ),
        child: Text(
          t.userStatus.protected,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return useTextLabels
        ? GestureDetector(
            onTap: onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildAvatar(context, theme), ..._buildTextLabels(context, theme)],
            ),
          )
        : GestureDetector(onTap: onTap, child: _buildAvatar(context, theme));
  }
}

// Extension to add warning color to ColorScheme if not available
extension ColorSchemeExtension on ColorScheme {
  Color? get warning => brightness == Brightness.light ? Colors.orange.shade600 : Colors.orange.shade400;
}
