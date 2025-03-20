import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/career_guidance_tab.dart';
import 'tabs/knowledge_centre_tab.dart';
import 'tabs/about_tab.dart';
import 'tabs/contact_us_tab.dart';
import 'widgets/custom_tab_bar.dart';
import '../data/tabs_layout.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _showImage = false;

  // List of all tab contents
  final List<Widget> _tabContents = [
    const HomeTab(),
    const CareerGuidanceTab(),
    AboutTab(),
    const ContactUsTab(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _showImage = false;

      // Delay the image fade-in until the tab transition completes
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted && _selectedIndex == index) {
          setState(() {
            _showImage = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Solid Color Background (Visible During Transition)
          Positioned.fill(
            child: Container(
              color: tabBackgroundColors[_selectedIndex],
            ),
          ),

          // Image (Fades In AFTER Transition Completes)
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _showImage ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
              // child: Image.asset(
              //   'assets/images/career.png',
              //   fit: BoxFit.cover,
              // ),
            ),
          ),

          // IndexedStack to switch between different tab content with smooth animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0), // Slide from right to left
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _tabContents[_selectedIndex], // Dynamic content based on selected tab
          ),

          // Custom Tab Bar
          Align(
            alignment: Alignment.topCenter,
            child: CustomTabBar(
              tabs: tabTitles,
              selectedIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
              logoUrl: 'assets/images/3.png',
            ),
          ),
        ],
      ),
    );
  }
}
