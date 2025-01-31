import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';
import 'dart:async';

class CareerGuidanceTab extends StatefulWidget {
  const CareerGuidanceTab({Key? key}) : super(key: key);

  @override
  _CareerGuidanceTabState createState() => _CareerGuidanceTabState();
}

class _CareerGuidanceTabState extends State<CareerGuidanceTab> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  final List<Map<String, String>> imageQuotes = [
    {
      "image": "assets/images/Founder.jpeg",
      "quote": "Start early and stay ahead in your career!"
    },
    {
      "image": "assets/images/Founder2.jpeg",
      "quote": "Focus on building real skills that matter."
    },
    {
      "image": "assets/images/Founder.jpeg",
      "quote": "Your portfolio is your resume, make it strong."
    },
    {
      "image": "assets/images/Founder2.jpeg",
      "quote": "Never stop learning, the industry evolves fast."
    },
    {
      "image": "assets/images/Founder.jpeg",
      "quote": "Networking is the key to opportunities."
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Auto-transition images every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % imageQuotes.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 70),
      key: ValueKey<int>(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tabBackgroundColors[2],
            tabGradientColors[2],
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            buildCareerGuidanceTab(context),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  // Header section
  Widget _buildHeaderSection() {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 5, horizontal: 50).add(EdgeInsets.only(top: 5)),
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    'Get expert advice to fast-track your career!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5).add(EdgeInsets.only(bottom: 1)),
            child: GestureDetector(
              onTap: () {
                // Action to book consultation
              },
              child: Container(
                height: 90,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Book Consultation',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Career Guidance Tab with transitioning images
  Widget buildCareerGuidanceTab(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Logo (left-aligned, taking up half the screen width)
            Padding(
              padding:
                  const EdgeInsets.only(top: 3).add(EdgeInsets.symmetric(horizontal: 35)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      "assets/images/Aca.png",
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.11,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Transitioning Image & Quote Section (left-aligned)
            Padding(
              padding:
                  const EdgeInsets.only(top: 3).add(EdgeInsets.symmetric(horizontal: 35)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: ClipRRect(
                      key: ValueKey<int>(_currentIndex),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                      child: Stack(
                        children: [
                          // Transitioning image
                          Image.asset(
                            imageQuotes[_currentIndex]["image"]!,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.60,
                            fit: BoxFit.cover,
                          ),

                          // Vignette Overlay
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.62,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                              gradient: RadialGradient(
                                center: Alignment.bottomCenter,
                                radius: 1.0,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.9),
                                ],
                              ),
                            ),
                          ),

                          // Quote positioned on the dark vignette area
                          Positioned(
                            bottom: 30,
                            left: 20,
                            right: 20,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 800),
                              child: Text(
                                imageQuotes[_currentIndex]["quote"]!,
                                key: ValueKey<int>(_currentIndex),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
