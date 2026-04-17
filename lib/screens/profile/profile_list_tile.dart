import 'package:flutter/material.dart';
import 'package:jelzy/widgets/app_icon.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../i18n/strings.g.dart';
import '../../models/jellyfin_public_user.dart';
import '../../theme/mono_tokens.dart';
import 'user_avatar_widget.dart';

class ProfileListTile extends StatelessWidget {
  final JellyfinPublicUser user;
  final VoidCallback onTap;
  final bool isCurrentUser;
  final bool showTrailingIcon;
  final bool allowCurrentUserTap;

  const ProfileListTile({
    super.key,
    required this.user,
    required this.onTap,
    this.isCurrentUser = false,
    this.showTrailingIcon = true,
    this.allowCurrentUserTap = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? trailing;
    if (isCurrentUser) {
      trailing = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(tokens(context).radiusMd),
        ),
        child: Text(
          t.userStatus.current,
          style: TextStyle(
            fontSize: 10,
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      );
    } else if (showTrailingIcon) {
      trailing = const AppIcon(Symbols.chevron_right_rounded, fill: 1);
    }

    return ListTile(
      leading: UserAvatarWidget(user: user, size: 40, showIndicators: false),
      title: Text(user.name),
      subtitle: user.hasPassword
          ? Row(
              children: [
                Text(
                  t.userStatus.protected,
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.secondary, fontWeight: FontWeight.w500),
                ),
              ],
            )
          : null,
      trailing: trailing,
      onTap: isCurrentUser && !allowCurrentUserTap ? null : onTap,
    );
  }
}
