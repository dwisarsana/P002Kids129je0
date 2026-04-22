import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import 'home_screen.dart';
import '../account/history_screen.dart';
import '../account/favorites_screen.dart';
import '../account/settings_screen.dart';
import '../production/upload_screen.dart';
import 'dart:ui';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openUpload() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmSand,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;

          return Stack(
            children: [
              // Main content shifts over if wide
              Row(
                children: [
                  if (isWide)
                    _buildSideRail(),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _screens,
                    ).animate(key: ValueKey(_currentIndex)).fade(duration: 300.ms),
                  ),
                ],
              ),

              // Floating Glassmorphic Top Bar for mobile
              if (!isWide)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildTopGlassNav(),
                ),

              // Floating Action Button for creation (organic shape)
              Positioned(
                bottom: isWide ? 40 : 30,
                right: isWide ? 40 : 20,
                child: GestureDetector(
                  onTap: _openUpload,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: AppTheme.leafGradient,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.leafGreen.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(CupertinoIcons.wand_stars, color: Colors.white, size: 32),
                  ).animate().scale(begin: const Offset(0,0), curve: Curves.elasticOut, duration: 800.ms),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopGlassNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 15, left: 20, right: 20),
          decoration: BoxDecoration(
            color: AppTheme.mistWhite.withValues(alpha: 0.7),
            border: Border(bottom: BorderSide(color: AppTheme.mistWhite.withValues(alpha: 0.4))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, CupertinoIcons.home, 'Home'),
              _navItem(1, CupertinoIcons.time, 'History'),
              _navItem(2, CupertinoIcons.heart, 'Favorites'),
              _navItem(3, CupertinoIcons.settings, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideRail() {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: AppTheme.mistWhite,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navItem(0, CupertinoIcons.home, 'Home', isVertical: true),
          const SizedBox(height: 40),
          _navItem(1, CupertinoIcons.time, 'History', isVertical: true),
          const SizedBox(height: 40),
          _navItem(2, CupertinoIcons.heart, 'Favorites', isVertical: true),
          const SizedBox(height: 40),
          _navItem(3, CupertinoIcons.settings, 'Settings', isVertical: true),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, {bool isVertical = false}) {
    bool isSelected = _currentIndex == index;
    final color = isSelected ? AppTheme.mossGreen : AppTheme.slate;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: isSelected ? 28 : 24),
        const SizedBox(height: 4),
        if (isSelected)
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))
      ],
    );

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeOutCubic,
        padding: isVertical ? const EdgeInsets.symmetric(vertical: 10) : const EdgeInsets.symmetric(horizontal: 10),
        child: content,
      ),
    );
  }
}
