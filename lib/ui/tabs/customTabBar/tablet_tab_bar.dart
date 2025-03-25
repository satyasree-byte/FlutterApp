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

  const TabletTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.logoUrl,
  }) : super(key: key);

  @override
  _TabletTabBarState createState() => _TabletTabBarState();
}

class _TabletTabBarState extends State<TabletTabBar> {
  List<bool> _isHovered = [];

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
        color: Colors.black.withOpacity(0.8),
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
          // Logo with constrained size
          SizedBox(
            width: logoSize,
            height: logoSize,
            child: SvgPicture.asset(
              widget.logoUrl,
              fit: BoxFit.contain,
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