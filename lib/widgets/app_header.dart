import 'package:flutter/material.dart';
import 'package:meteo_rigolote/services/navigation_service.dart';

/// Reusable header widget with navigation controls
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showMenuButton;
  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Widget? leading;

  const AppHeader({
    super.key,
    this.showBackButton = true,
    this.showMenuButton = false,
    this.title,
    this.actions,
    this.onBackPressed,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ?? 
          (showBackButton
              ? IconButton(
                  onPressed: onBackPressed ?? () => NavigationService.pop(context),
                  icon: const Icon(Icons.arrow_back),
                )
              : showMenuButton
                  ? IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu),
                    )
                  : null),
      title: title != null ? Text(title!) : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
