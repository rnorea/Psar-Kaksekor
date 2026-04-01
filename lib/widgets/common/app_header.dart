import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';

/// Reusable circular avatar used in headers and nav.
class AppAvatar extends StatelessWidget {
  final String initial;
  final double size;

  const AppAvatar({
    super.key,
    required this.initial,
    this.size = kAvatarSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: colorLight, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Top header with dark-green background and rounded bottom corners.
/// Accepts a [title] widget on the left and an optional [action] on the right.
/// Pass [searchSlot] to include a search bar below the title row.
class AppHeader extends StatelessWidget {
  final Widget title;
  final Widget? action;
  final Widget? searchSlot;

  const AppHeader({
    super.key,
    required this.title,
    this.action,
    this.searchSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: colorDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kRadiusHeader),
          bottomRight: Radius.circular(kRadiusHeader),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title,
              if (action != null) action!,
            ],
          ),
          if (searchSlot != null) ...[
            const SizedBox(height: 10),
            searchSlot!,
          ],
        ],
      ),
    );
  }
}

/// Tap-only search bar used on the Home screen.
class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(11),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.search, size: 13, color: Colors.white.withOpacity(0.45)),
            const SizedBox(width: 7),
            Text(
              'Search vegetables, rice...',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 11.5,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}