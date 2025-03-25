import 'package:flutter/material.dart';
import 'tabs/career_guidance_tab.dart';
import 'tabs/knowledge_centre_tab.dart';
import '../data/tabs_layout.dart';
import 'tabs/customTabBar/mobile_tab_bar.dart';
import 'tabs/customTabBar/tablet_tab_bar.dart';
import 'tabs/customTabBar/desktop_tab_bar.dart';
import 'tabs/about/founder_card.dart';
import '../constants.dart';
import 'widgets/ResponsiveCustomTab.dart';
import 'tabs/responsiveHome.dart';
import 'tabs/responsiveContactUs.dart';
import 'tabs/responsiveAbout.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _showImage = false;
  bool _isMenuOpen = false;

  final List<Widget> _tabContents = [
    const responsive_Home(),
    ResponsiveAbout(founders: defaultFounders),
    const ResponsiveContact(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _showImage = false;
      _isMenuOpen = false; // ADDED: Close menu when tab changes
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted && _selectedIndex == index) {
        setState(() {
          _showImage = true;
        });
      }
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background color
          Positioned.fill(
            child: Container(
              color: tabBackgroundColors[_selectedIndex],
            ),
          ),

          // Fading image
          Positioned.fill(
            top: kToolbarHeight,
            child: AnimatedOpacity(
              opacity: _showImage ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
            ),
          ),

          // Main content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _tabContents[_selectedIndex],
          ),

          // Tab bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: ResponsiveCustomTab(
                tabs: tabTitles,
                selectedIndex: _selectedIndex,
                onTabSelected: _onTabSelected,
                logoUrl: 'assets/images/4.svg',
                isMenuOpen: _isMenuOpen,
                toggleMenu: _toggleMenu,
              ),
            ),
          ),

          // Overlay to close menu when tapping outside
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                behavior: HitTestBehavior.translucent,
              ),
            ),

          // Menu content
          if (_isMenuOpen)
            Positioned(
              top: kToolbarHeight + MediaQuery.of(context).padding.top,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: screenWidth * 0.6,
                  constraints: BoxConstraints(
                    maxWidth: 300,
                    maxHeight: screenHeight * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: tabTitles.map((tab) {
                        final index = tabTitles.indexOf(tab);
                        return InkWell(
                          onTap: () {
                            _onTabSelected(index); // This will automatically close menu
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.white70,
                                fontSize: 16,
                                fontWeight: _selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}