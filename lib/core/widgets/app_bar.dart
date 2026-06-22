import 'package:flutter/material.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.topText,
    this.bottomText,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  final String title;
  final String? topText;
  final String? bottomText;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (topText != null) height += 18;
    if (bottomText != null) height += 18;
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      toolbarHeight: preferredSize.height,
      leading: leading,
      centerTitle: centerTitle,
      actions: actions,
      title: Column(
        crossAxisAlignment:
            centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topText != null)
            Text(
              topText!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          if (bottomText != null)
            Text(
              bottomText!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
