import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final String logoUrl;
  final bool isMenuOpen;
  final VoidCallback toggleMenu;

  const MobileTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.logoUrl,
    required this.isMenuOpen,
    required this.toggleMenu,
  }) : super(key: key);

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
          SvgPicture.asset(
            logoUrl,
            width: logoSize,
            height: logoSize,
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: toggleMenu,
          ),
        ],
      ),
    );
  }
}