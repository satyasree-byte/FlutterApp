import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/ui/tabs/Services/services.dart'; // Adjust the path accordingly
import 'services/bookServiceForm.dart';

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

  // Track hover state for each service link
  final Map<String, bool> _hoverStates = {
    "Career Guidance": false,
    "Personalized Consultation": false,
    "Resume Building": false,
    "Interview Coaching": false,
    "Quality Assurance Training": false,
    "Programming Training": false,
  };

  final List<Map<String, dynamic>> imageQuotes = [
    {
      "quote": "Start early and stay ahead in your career!",
      "icon": Icons.rocket_launch_rounded,
      "color": const Color(0xFF7C3AED),
    },
    {
      "quote": "Focus on building real skills that matter.",
      "icon": Icons.psychology_rounded,
      "color": const Color(0xFF0EA5E9),
    },
    {
      "quote": "Your portfolio is your resume — make it strong.",
      "icon": Icons.work_outline_rounded,
      "color": const Color(0xFF10B981),
    },
    {
      "quote": "Never stop learning. The industry evolves fast.",
      "icon": Icons.auto_stories_rounded,
      "color": const Color(0xFFF59E0B),
    },
    {
      "quote": "Networking is the key to opportunities.",
      "icon": Icons.people_rounded,
      "color": const Color(0xFFEC4899),
    },
  ];

  // Keys for each section
  final GlobalKey _careerGuidanceKey = GlobalKey();
  final GlobalKey _personalizedConsultationKey = GlobalKey();
  final GlobalKey _resumeBuildingKey = GlobalKey();
  final GlobalKey _interviewCoachingKey = GlobalKey();
  final GlobalKey _qualityAssuranceTrainingKey = GlobalKey();
  final GlobalKey _programmingTrainingKey = GlobalKey();

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

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 70),
      key: ValueKey<int>(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tabBackgroundColors[0],
            tabGradientColors[0],
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 35),
            buildCareerGuidanceTab(context),
            const SizedBox(height: 35),
            _buildServiceSection(
              key: _careerGuidanceKey,
              title: "Career Guidance",
              description: "Unlock your potential and take charge of your career path with expert career guidance. Whether you're just starting or looking to advance, we provide tailored advice to help you achieve your career goals and navigate the professional world with confidence. Don’t wait for success—plan it today!",
              imagePath: "assets/images/Service1.png",
            ),
            const SizedBox(height: 35),
            _buildServiceSection(
              key: _personalizedConsultationKey,
              title: "Personalized Consultation",
              description: "Every career journey is unique, which is why our personalized consultation is tailored to your specific needs. Our experts will work with you one-on-one to craft a strategic plan that propels you towards your goals. Book now to start your personalized career transformation today!",
              imagePath: "assets/images/ServiceTwo.png",
            ),
            const SizedBox(height: 35),
            _buildServiceSection(
              key: _resumeBuildingKey,
              title: "Resume Building",
              description: "Your resume is your first impression—make it unforgettable. Our experts create stunning, standout resumes that capture your skills and experience, ensuring you land the job you deserve. Get a resume that gets you noticed. Book your resume-building session now!",
              imagePath: "assets/images/ServiceThree.png",
            ),
            const SizedBox(height: 35),
            _buildServiceSection(
              key: _interviewCoachingKey,
              title: "Interview Coaching",
              description: "A great interview can open doors, but the right preparation will ensure you walk through them with confidence. Our interview coaching will help you tackle every question with poise and position yourself as the ideal candidate. Schedule your session now and ace your next interview!",
              imagePath: "assets/images/Service4.jpg",
            ),
            const SizedBox(height: 35),
            _buildServiceSection(
              key: _qualityAssuranceTrainingKey,
              title: "Quality Assurance Training",
              description: "Enhance the quality of your software projects and master the most effective testing techniques with our comprehensive QA training. Our hands-on approach ensures you're equipped with the skills to deliver top-notch, bug-free applications. Level up your QA skills—book your training today!",
              imagePath: "assets/images/Service5.png",
            ),
            const SizedBox(height: 35),
            _buildServiceSection(
              key: _programmingTrainingKey,
              title: "Programming Training",
              description: "Ready to become a coding expert? Whether you’re a beginner or looking to level up, our programming training covers everything from basic syntax to complex algorithms. Learn at your own pace, and gain hands-on experience with real-world projects. Enroll now and transform your coding skills today!",
              imagePath: "assets/images/Service6.png",
            ),
            const SizedBox(height: 35),
            _footerSection(context),
          ],
        ),
      ),
    );
  }

  // Header section
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50).add(EdgeInsets.only(top: 5)),
      height: MediaQuery.of(context).size.height * 0.15,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  Text(
                    'Get expert advice to fast-track your career!',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Service Section Widget
  Widget _buildServiceSection({
    required GlobalKey key,
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side: Text
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the BookingForm page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingForm(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 18,
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
          ),
          const SizedBox(width: 20), // Space between text and image
          // Right Side: Image
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Ensure the image is not cropped
                height: 200, // Adjust height as needed
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              padding: const EdgeInsets.only(top: 3).add(EdgeInsets.symmetric(horizontal: 35)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                ),
              ),
            ),

            // Row for Image & Text Section (left: image, right: text)
            Padding(
              padding: const EdgeInsets.only(top: 1).add(EdgeInsets.symmetric(horizontal: 10)),
              child: Row(
                children: [
                  // Transitioning Quote Panel (no photos)
                  Expanded(
                    flex: 1,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: ClipRRect(
                        key: ValueKey<int>(_currentIndex),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (imageQuotes[_currentIndex]["color"] as Color).withOpacity(0.18),
                                Colors.black87,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                imageQuotes[_currentIndex]["icon"] as IconData,
                                color: imageQuotes[_currentIndex]["color"] as Color,
                                size: 80,
                              ),
                              const SizedBox(height: 32),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  '“${imageQuotes[_currentIndex]["quote"]}”',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.5,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15.0,
                                        color: Colors.black.withOpacity(0.6),
                                        offset: const Offset(3.0, 3.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Right-aligned text section
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2).add(EdgeInsets.symmetric(horizontal: 10)),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.8),
                              Colors.purple.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // People's Experience
                            SizedBox(height: 20),

                            // Services Provided
                            Text(
                              "Services Provided:",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5, // Adjustable height
                              width: MediaQuery.of(context).size.width * 0.8, // Adjustable width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildServiceLink("Career Guidance", _careerGuidanceKey),
                                  _buildServiceLink("Personalized Consultation", _personalizedConsultationKey),
                                  _buildServiceLink("Resume Building", _resumeBuildingKey),
                                  _buildServiceLink("Interview Coaching", _interviewCoachingKey),
                                  _buildServiceLink("Quality Assurance Training", _qualityAssuranceTrainingKey),
                                  _buildServiceLink("Programming Training", _programmingTrainingKey),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            // Book Consultation Button
                            GestureDetector(
                              onTap: () {
                                // Navigate to the BookingForm page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingForm(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.8, // Increased width
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    'Book Consultation Now',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceLink(String text, GlobalKey key) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoverStates[text] = true; // Set hover state for this specific link
      }),
      onExit: (_) => setState(() {
        _hoverStates[text] = false; // Reset hover state for this specific link
      }),
      child: GestureDetector(
        onTap: () => _scrollToSection(key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: _hoverStates[text]! ? Colors.green.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "$text",
            style: TextStyle(
              fontSize: _hoverStates[text]! ? 20 : 18, // Increase font size on hover
              fontWeight: _hoverStates[text]! ? FontWeight.bold : FontWeight.normal,
              color: _hoverStates[text]! ? Colors.green : Colors.white, // Change color on hover
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget _footerSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.black,
      child: Column(
        children: [
          // Social Media Links (LinkedIn, WhatsApp, GitHub)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.linkedin,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: () {
                  _launchURL('https://www.linkedin.com/in/akashdwivedi/');
                },
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  size: 30,
                ),
                onPressed: () {
                  _launchURL('https://wa.me/yourphonenumber');
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.code,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  _launchURL('https://github.com/akashdwivedi');
                },
              ),
            ],
          ),

          // Footer Text
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Stay connected with us for updates, career tips, and educational resources.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Website Check Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'For more career and education tips, visit our educational portal.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}