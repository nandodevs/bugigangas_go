import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'floating_bottom_nav.dart';

/// Shell widget that wraps all tab-bar routes with the [FloatingBottomNav].
///
/// This widget is used as the `builder` in a `ShellRoute` and renders
/// a `Scaffold` with the bottom nav and the current child page.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  /// Maps [ShellRoute] index to the actual GoRouter branch location.
  static int _indexFromLocation(String location) {
    if (location.startsWith('/buy-postage')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/support')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // home
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/buy-postage');
      case 2:
        context.go('/search');
      case 3:
        context.go('/support');
      case 4:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingBottomNav(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
        ),
      ),
    );
  }
}
