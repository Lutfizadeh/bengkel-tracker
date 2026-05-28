import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../constants/app_colors.dart';

const String _iconamoonProfileFill =
  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="M8 7a4 4 0 1 1 8 0a4 4 0 0 1-8 0m0 6a5 5 0 0 0-5 5a3 3 0 0 0 3 3h12a3 3 0 0 0 3-3a5 5 0 0 0-5-5z" clip-rule="evenodd"/></svg>';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    super.key,
    required this.activeIndex,
    required this.onCenterTap,
    this.onHomeTap,
    this.onHistoryTap,
    this.onChatTap,
    this.onProfileTap,
  });

  final int activeIndex;
  final VoidCallback onCenterTap;
  final VoidCallback? onHomeTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: 84,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(top: BorderSide(color: Color(0xFFEAE7E3))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavItem(
                    icon: Ic.round_home,
                    label: 'Beranda',
                    active: activeIndex == 0,
                    onTap: onHomeTap,
                  ),
                  NavItem(
                    icon: Ic.baseline_history,
                    label: 'History',
                    active: activeIndex == 1,
                    onTap: onHistoryTap,
                  ),
                  const SizedBox(width: 62),
                  NavItem(
                    icon: MaterialSymbols.chat_rounded,
                    label: 'Chat',
                    active: activeIndex == 3,
                    onTap: onChatTap,
                  ),
                  NavItem(
                    icon: _iconamoonProfileFill,
                    label: 'Profil',
                    active: activeIndex == 4,
                    onTap: onProfileTap,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: onCenterTap,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orange,
                  ),
                  child: Icon(
                    activeIndex == 2 ? Icons.navigation_rounded : Icons.add_rounded,
                    color: AppColors.white,
                    size: activeIndex == 2 ? 24 : 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    this.onTap,
  });

  final String icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: active ? 1 : 0.7,
              child: Iconify(
                icon,
                size: 25,
                color: active ? AppColors.orange : AppColors.gray,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: active ? AppColors.orange : AppColors.gray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
