// desktop_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/language_toggle.dart';

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
  bool _isLogoHovered = false;
  bool _isLogoPressed = false;

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
          // Logo with hover glow + scale + tooltip
          Tooltip(
            message: 'EDUVISE.AI',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF64FFDA).withOpacity(0.4)),
            ),
            verticalOffset: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isLogoHovered = true),
              onExit: (_) => setState(() {
                _isLogoHovered = false;
                _isLogoPressed = false;
              }),
              child: GestureDetector(
                onTap: widget.onLogoTapped ?? () {},
                onTapDown: (_) => setState(() => _isLogoPressed = true),
                onTapUp: (_) => setState(() => _isLogoPressed = false),
                onTapCancel: () => setState(() => _isLogoPressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  transform: Matrix4.identity()
                    ..scale(_isLogoPressed ? 0.88 : (_isLogoHovered ? 1.10 : 1.0)),
                  transformAlignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: _isLogoHovered && !_isLogoPressed
                        ? [
                            BoxShadow(
                              color: const Color(0xFF64FFDA).withOpacity(0.5),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                  child: SvgPicture.asset(
                    widget.logoUrl,
                    width: logoSize,
                    height: logoSize,
                  ),
                ),
              ),
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
          const SizedBox(width: 16),
          const LanguageToggle(),
        ],
      ),
    );
  }
}