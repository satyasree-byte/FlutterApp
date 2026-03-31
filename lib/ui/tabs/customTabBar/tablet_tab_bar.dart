// tablet_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart'; // Adjust import path

class TabletTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final String logoUrl;
  final VoidCallback? onLogoTapped;

  const TabletTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.logoUrl,
    this.onLogoTapped,
  }) : super(key: key);

  @override
  _TabletTabBarState createState() => _TabletTabBarState();
}

class _TabletTabBarState extends State<TabletTabBar> {
  List<bool> _isHovered = [];
  bool _isLogoHovered = false;
  bool _isLogoPressed = false;

  @override
  void initState() {
    super.initState();
    _isHovered = List.generate(widget.tabs.length, (index) => false);
  }

  double _getResponsiveSize(double screenWidth, double tabletValue, double desktopValue) {
    if (screenWidth >= ScreenSize.desktop) {
      return desktopValue;
    } else if (screenWidth >= ScreenSize.tablet) {
      return tabletValue;
    } else {
      return tabletValue * 0.8; // Smaller than tablet
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= ScreenSize.desktop;

    // Responsive sizing based on your constants
    final logoSize = _getResponsiveSize(screenWidth, 80, 100);
    final tabFontSize = _getResponsiveSize(screenWidth, 18, 22);
    final tabPadding = _getResponsiveSize(screenWidth, 16, 20);
    final containerPadding = _getResponsiveSize(screenWidth, 20, 24);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: containerPadding * 0.5,
        horizontal: containerPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo with hover + press interaction
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isLogoHovered = true),
            onExit: (_) => setState(() {
              _isLogoHovered = false;
              _isLogoPressed = false;
            }),
            child: GestureDetector(
              onTap: widget.onLogoTapped,
              onTapDown: (_) => setState(() => _isLogoPressed = true),
              onTapUp: (_) => setState(() => _isLogoPressed = false),
              onTapCancel: () => setState(() => _isLogoPressed = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                transform: Matrix4.identity()
                  ..scale(_isLogoPressed ? 0.88 : (_isLogoHovered ? 1.08 : 1.0)),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _isLogoHovered && !_isLogoPressed
                      ? [
                          BoxShadow(
                            color: const Color(0xFF64FFDA).withOpacity(0.45),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ]
                      : [],
                ),
                child: SizedBox(
                  width: logoSize,
                  height: logoSize,
                  child: SvgPicture.asset(
                    widget.logoUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Tabs with improved sizing
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.tabs.length, (index) {
                  final isSelected = index == widget.selectedIndex;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: tabPadding * 0.5),
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isHovered[index] = true),
                      onExit: (_) => setState(() => _isHovered[index] = false),
                      child: GestureDetector(
                        onTap: () => widget.onTabSelected(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: tabPadding,
                            vertical: tabPadding * 0.6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected || _isHovered[index] 
                                ? Colors.white.withOpacity(0.1) 
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: tabFontSize,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}