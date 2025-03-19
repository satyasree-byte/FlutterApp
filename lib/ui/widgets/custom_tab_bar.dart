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
  // Initialize _isHovered with a list of false values, one for each tab
  List<bool> _isHovered = List.generate(0, (index) => false);

  @override
  void initState() {
    super.initState();
    // Initialize the _isHovered list with the correct length
    _isHovered = List.generate(widget.tabs.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),  // Adjusted padding for better spacing
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
        mainAxisAlignment: MainAxisAlignment.start,  // Align the content to the start
        children: [
          // Logo Image before Home Tab
          SizedBox(
            width: 240,  // Increased width for the logo
            height: 50,  // Increased height for the logo
            child: Image.asset(
              widget.logoUrl,  // Load logo from assets
              fit: BoxFit.contain,  // Better fit for the image
            ),
          ),
          
          // Add spacing between the logo and tabs
          SizedBox(width: 1),  // Increased space between logo and tabs

          // Tabs with hover effect
          Row(
            mainAxisAlignment: MainAxisAlignment.start,  // Align tabs to the start
            children: List.generate(widget.tabs.length, (index) {
              final isSelected = index == widget.selectedIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),  // Increased horizontal spacing between tabs
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovered[index] = true;  // Set hover state to true
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovered[index] = false;  // Reset hover state to false
                    });
                  },
                  child: GestureDetector(
                    onTap: () => widget.onTabSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),  // Adjusted padding for tabs
                      decoration: BoxDecoration(
                        color: isSelected || _isHovered[index] ? Colors.white.withOpacity(0.1) : Colors.transparent,  // Apply hover effect
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: _isHovered[index] ? 1.1 : 1.0,  // Scale the tab when hovered
                        child: Text(
                          widget.tabs[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 18,
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
        ],
      ),
    );
  }
}
