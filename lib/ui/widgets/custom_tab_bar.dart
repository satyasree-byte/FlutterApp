import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final String logoUrl;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.logoUrl,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  List<bool> _isHovered = List.generate(0, (index) => false);

  @override
  void initState() {
    super.initState();
    _isHovered = List.generate(widget.tabs.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing based on screen width
    final logoWidth = screenWidth * 0.20; // 15% of screen width
    final logoHeight = logoWidth * 0.6; // Maintain aspect ratio
    final tabFontSize = screenWidth * 0.015; // 2% of screen width
    final tabPadding = screenWidth * 0.025; // 1% of screen width

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: screenWidth * 0.02), // 2% padding
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          SizedBox(
            width: logoWidth, // Dynamic width
            height: logoHeight, // Dynamic height
            child: Image.asset(
              widget.logoUrl,
              fit: BoxFit.contain,
            ),
          ),

          // Tabs with hover effect
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(widget.tabs.length, (index) {
                  final isSelected = index == widget.selectedIndex;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: tabPadding), // Dynamic padding
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
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(horizontal: tabPadding, vertical: 8), // Dynamic padding
                          decoration: BoxDecoration(
                            color: isSelected || _isHovered[index] ? Colors.white.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            scale: _isHovered[index] ? 1.1 : 1.0,
                            child: Text(
                              widget.tabs[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: tabFontSize, // Dynamic font size
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