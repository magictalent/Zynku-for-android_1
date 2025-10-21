import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class PageWithBottomNav extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String? title;

  const PageWithBottomNav({
    super.key,
    required this.child,
    required this.currentIndex,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Navigation is handled in the CustomBottomNavigationBar
        },
      ),
    );
  }
}
