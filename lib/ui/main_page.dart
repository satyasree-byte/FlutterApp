import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';
import 'widgets/custom_tab_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _showImage = false; // Controls when the image fades in

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _showImage = false; // Ensure the image is hidden during the transition

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
              duration: const Duration(milliseconds: 1000), // Smooth fade-in
              child: Image.asset(
                'assets/images/career.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Tab Content with Animated Transition
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
            child: _buildTabContent(_selectedIndex),
          ),

          // Custom Tab Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomTabBar(
              tabs: tabTitles,
              selectedIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
 

  Widget _buildTabContent(int index) {
  return Container(
    key: ValueKey<int>(index),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          tabBackgroundColors[index],
          tabGradientColors[index],
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text Title
          Text(
            tabTitles[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          // Text Description
          Text(
            tabDescriptions[index],
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          // Animated Image
          AnimatedOpacity(
            opacity: 1.0, // You can make this dynamic based on your animation
            duration: const Duration(milliseconds: 1000), // Smooth fade-in
            child: Image.asset(
              'assets/images/career.png',
              width: 200, // Set the width to control image size
              height: 200, // Set the height to control image size
              fit: BoxFit.cover, // Keeps the aspect ratio while covering space
            ),
          ),
        ],
      ),
    ),
  );
}
}
