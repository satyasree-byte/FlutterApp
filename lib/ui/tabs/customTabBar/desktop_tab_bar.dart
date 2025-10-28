// desktop_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DesktopTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final String logoUrl;
  final VoidCallback? onLogoTapped;
  

  const DesktopTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.logoUrl,
    this.onLogoTapped,
  }) : super(key: key);

  @override
  _DesktopTabBarState createState() => _DesktopTabBarState();
}

class _DesktopTabBarState extends State<DesktopTabBar> {
  List<bool> _isHovered = [];

  @override
  void initState() {
    super.initState();
    _isHovered = List.generate(widget.tabs.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.09; // Dynamic logo size
    final tabFontSize = screenWidth * 0.017; // Dynamic font size
    final tabPadding = screenWidth * 0.025; // Dynamic padding

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      height:90,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(1.0),
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
          // Logo
          GestureDetector(
          onTap: widget.onLogoTapped ?? () {},
          child: SvgPicture.asset(
            widget.logoUrl,
            width: logoSize,
            height: logoSize,
          ),
        ),

          // Tabs with hover effect
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.tabs.length, (index) {
                  final isSelected = index == widget.selectedIndex;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: tabPadding),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered[index] = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered[index] = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () => widget.onTabSelected(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(horizontal: tabPadding, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected || _isHovered[index] ? Colors.white.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AnimatedScale(
                            duration: Duration(milliseconds: 200),
                            scale: _isHovered[index] ? 1.1 : 1.0,
                            child: Text(
                              widget.tabs[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: tabFontSize,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
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