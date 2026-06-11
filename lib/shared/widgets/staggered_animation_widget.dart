import 'package:flutter/material.dart';

/// A widget that animates its child with a fade + slide-up effect.
///
/// Each cell is delayed by [index] * 50ms so items appear one after another
/// in a staggered sequence.
class StaggeredAnimationCell extends StatefulWidget {
  final int index;
  final Widget child;

  const StaggeredAnimationCell({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<StaggeredAnimationCell> createState() => _StaggeredAnimationCellState();
}

class _StaggeredAnimationCellState extends State<StaggeredAnimationCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Staggered delay: 50ms between each card
    final delay = widget.index * 50;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
