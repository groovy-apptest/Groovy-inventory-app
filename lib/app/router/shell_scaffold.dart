import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _NavItem('/dashboard', Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    _NavItem('/inventory', Icons.inventory_2_outlined, Icons.inventory, 'Inventory'),
    _NavItem('/transactions', Icons.receipt_long_outlined, Icons.receipt_long, 'Transactions'),
    _NavItem('/profile', Icons.person_outlined, Icons.person, 'Profile'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.path));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _currentIndex(context);
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    if (isIOS) {
      return Scaffold(
        body: child,
        bottomNavigationBar: _IOSLiquidGlassNav(
          selectedIndex: selectedIndex,
          onTap: (index) => context.go(_tabs[index].path),
        ),
      );
    }

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Center(
          heightFactor: 1,
          child: _AndroidFloatingPillNav(
            items: _tabs,
            selectedIndex: selectedIndex,
            onTap: (index) => context.go(_tabs[index].path),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.path, this.icon, this.activeIcon, this.label);
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

// ---------------------------------------------------------------------------
// iOS — Native Liquid Glass Tab Bar
// ---------------------------------------------------------------------------

class _IOSLiquidGlassNav extends StatelessWidget {
  const _IOSLiquidGlassNav({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return CNTabBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      tint: AppColors.primary,
      items: const [
        CNTabBarItem(
          label: 'Dashboard',
          icon: CNSymbol('square.grid.2x2'),
          activeIcon: CNSymbol('square.grid.2x2.fill'),
          customIcon: Icons.dashboard_outlined,
          activeCustomIcon: Icons.dashboard,
        ),
        CNTabBarItem(
          label: 'Inventory',
          icon: CNSymbol('archivebox'),
          activeIcon: CNSymbol('archivebox.fill'),
          customIcon: Icons.inventory_2_outlined,
          activeCustomIcon: Icons.inventory,
        ),
        CNTabBarItem(
          label: 'Transactions',
          icon: CNSymbol('list.bullet.rectangle'),
          activeIcon: CNSymbol('list.bullet.rectangle.fill'),
          customIcon: Icons.receipt_long_outlined,
          activeCustomIcon: Icons.receipt_long,
        ),
        CNTabBarItem(
          label: 'Profile',
          icon: CNSymbol('person'),
          activeIcon: CNSymbol('person.fill'),
          customIcon: Icons.person_outlined,
          activeCustomIcon: Icons.person,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Android — Floating Pill Bottom Nav
// ---------------------------------------------------------------------------

class _AndroidFloatingPillNav extends StatelessWidget {
  const _AndroidFloatingPillNav({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.18),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final isSelected = index == selectedIndex;
            final item = items[index];
            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 14 : 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.grey.withValues(alpha: 0.16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: 28,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      child: isSelected
                          ? Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                item.label,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
