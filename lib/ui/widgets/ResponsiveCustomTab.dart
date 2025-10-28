import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../tabs/customTabBar/mobile_tab_bar.dart';
import '../tabs/customTabBar/tablet_tab_bar.dart';
import '../tabs/customTabBar/desktop_tab_bar.dart';
import '../../constants.dart';

class ResponsiveCustomTab extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final String logoUrl;
  final bool isMenuOpen;
  final VoidCallback toggleMenu;
  final VoidCallback? onLogoTapped; 

  const ResponsiveCustomTab({
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < ScreenSize.mobile) {
      return MobileTabBar(
        tabs: tabs,
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        logoUrl: logoUrl,
        isMenuOpen: isMenuOpen,
        toggleMenu: toggleMenu,
      );
    } else if (screenWidth < ScreenSize.tablet) {
      return TabletTabBar(
        tabs: tabs,
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        logoUrl: logoUrl,
      );
    } else {
      return DesktopTabBar(
        tabs: tabs,
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        logoUrl: logoUrl,
        onLogoTapped: onLogoTapped, 
      );
    }
  }
}