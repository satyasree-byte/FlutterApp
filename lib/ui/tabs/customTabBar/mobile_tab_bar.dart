import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final String logoUrl;
  final bool isMenuOpen;
  final VoidCallback toggleMenu;
  final VoidCallback? onLogoTapped;

  const MobileTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.logoUrl,
    required this.isMenuOpen,
    required this.toggleMenu,
    this.onLogoTapped,
  }) : super(key: key);

  @override
  _MobileTabBarState createState() => _MobileTabBarState();
}

class _MobileTabBarState extends State<MobileTabBar>
    with SingleTickerProviderStateMixin {
  bool _isLogoPressed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.15;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: widget.onLogoTapped,
            onTapDown: (_) => setState(() => _isLogoPressed = true),
            onTapUp: (_) => setState(() => _isLogoPressed = false),
            onTapCancel: () => setState(() => _isLogoPressed = false),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return AnimatedScale(
                  scale: _isLogoPressed ? 0.85 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: _isLogoPressed
                          ? []
                          : [
                              BoxShadow(
                                color: const Color(0xFF64FFDA).withOpacity(
                                    0.12 + 0.22 * _pulseAnimation.value),
                                blurRadius: 10 + 10 * _pulseAnimation.value,
                                spreadRadius: 1,
                              ),
                            ],
                    ),
                    child: child,
                  ),
                );
              },
              child: SvgPicture.asset(
                widget.logoUrl,
                width: logoSize,
                height: logoSize,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: widget.toggleMenu,
          ),
        ],
      ),
    );
  }
}
