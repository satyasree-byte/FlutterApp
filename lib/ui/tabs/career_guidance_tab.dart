import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/ui/tabs/Services/services.dart'; // Adjust the path accordingly

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
            // Colors.transparent,
            // Colors.transparent,
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
            ServiceSection(
              title: "Career Guidance",
              description: "Unlock your potential and take charge of your career path with expert career guidance. Whether you're just starting or looking to advance, we provide tailored advice to help you achieve your career goals and navigate the professional world with confidence. Don’t wait for success—plan it today!",
              imagePath: "assets/images/Service1.png",
              onBookNowPressed: () {
                // Navigate to the booking page for Career Guidance
              //  _navigateToBookingPage(context, "Career Guidance");
            },
            ),
            const SizedBox(height: 35),
            ServiceSection(
              title: "Personalized Consultation",
              description: "Every career journey is unique, which is why our personalized consultation is tailored to your specific needs. Our experts will work with you one-on-one to craft a strategic plan that propels you towards your goals. Book now to start your personalized career transformation today!",
              imagePath: "assets/images/ServiceTwo.png",
              onBookNowPressed: () {
                // Navigate to the booking page for Career Guidance
              //  _navigateToBookingPage(context, "Personalized Consultation");
            },
            ),
            const SizedBox(height: 35),
            ServiceSection(
              title: "Resume Building",
              description: "Your resume is your first impression—make it unforgettable. Our experts create stunning, standout resumes that capture your skills and experience, ensuring you land the job you deserve. Get a resume that gets you noticed. Book your resume-building session now!",
              imagePath: "assets/images/ServiceThree.png",
              onBookNowPressed: () {
                // Navigate to the booking page for Career Guidance
               // _navigateToBookingPage(context, "Personalized Consultation");
            },
            ),
            const SizedBox(height: 35),
            ServiceSection(
              title: "Interview Coaching",
              description: "A great interview can open doors, but the right preparation will ensure you walk through them with confidence. Our interview coaching will help you tackle every question with poise and position yourself as the ideal candidate. Schedule your session now and ace your next interview!",
              imagePath: "assets/images/Service4.jpg",
              onBookNowPressed: () {
                // Navigate to the booking page for Career Guidance
              //  _navigateToBookingPage(context, "Personalized Consultation");
            },
            ),
            const SizedBox(height: 35),
            ServiceSection(
              title: "Quality Assurance Training",
              description: "Enhance the quality of your software projects and master the most effective testing techniques with our comprehensive QA training. Our hands-on approach ensures you're equipped with the skills to deliver top-notch, bug-free applications. Level up your QA skills—book your training today!",
              imagePath: "assets/images/Service5.png",
              onBookNowPressed: () {
                // Navigate to the booking page for Career Guidance
               // _navigateToBookingPage(context, "Personalized Consultation");
            },
            ),
            const SizedBox(height: 35),
            ServiceSection(
              title: "Programming Training",
              description: "Ready to become a coding expert? Whether you’re a beginner or looking to level up, our programming training covers everything from basic syntax to complex algorithms. Learn at your own pace, and gain hands-on experience with real-world projects. Enroll now and transform your coding skills today!",
              imagePath: "assets/images/Service6.png",
              onBookNowPressed: () {
                // Navigate to the booking page for Career Guidance
               // _navigateToBookingPage(context, "Personalized Consultation");
            },
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
      padding:const EdgeInsets.symmetric(vertical: 5, horizontal: 50).add(EdgeInsets.only(top: 5)),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
        ],
      ),
    );
  }

   Widget _servicesSectionOne() {
    return Container(
         padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 50).add(EdgeInsets.only(top: 150)),
      height: MediaQuery.of(context).size.height * 0.3,
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
    );
   }

    Widget servicesSectionTwo() {
    return Container(
         padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 50).add(EdgeInsets.only(top: 150)),
      height: MediaQuery.of(context).size.height * 0.3,
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
    );
   }

    Widget servicesSectionThree() {
    return Container(
         padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 50).add(EdgeInsets.only(top: 150)),
      height: MediaQuery.of(context).size.height * 0.3,
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
    );
   }

    Widget servicesSectionFour() {
    return Container(
         padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 50).add(EdgeInsets.only(top: 150)),
      height: MediaQuery.of(context).size.height * 0.3,
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
    );
   }

    Widget servicesSectionFive() {
    return Container(
         padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 50).add(EdgeInsets.only(top: 150)),
      height: MediaQuery.of(context).size.height * 0.3,
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
                      "assets/images/LogoMain.png",
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.11,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Row for Image & Text Section (left: image, right: text)
            Padding(
              padding:
                  const EdgeInsets.only(top: 1).add(EdgeInsets.symmetric(horizontal: 10)),
              child: Row(
                children: [
                  // Transitioning Image & Quote Section (left-aligned)
                  Expanded(
                    flex: 1,
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
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.height * 0.62,
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
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "“", // Stylish opening quote
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      TextSpan(
                                        text: imageQuotes[_currentIndex]["quote"]!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 15.0,
                                              color: Colors.black.withOpacity(0.6), // Runtime color
                                              offset: Offset(3.0, 3.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextSpan(
                                        text: "”", // Stylish closing quote
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withOpacity(0.7),
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
                    ),
                  ),

                  // Right-aligned text section
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2).add(EdgeInsets.symmetric(horizontal: 10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // People's Experience
                          Text(
                            "Expertise :",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Akash Dwivedi: Our Founder, a seasoned AI engineer with over 11 years of expertise in Generative AI, driving innovation and excellence in the field.",
                            style: TextStyle(
                              fontSize: 19,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Services Provided
                          Text(
                            "Services Provided:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "- Career Guidance\n- Personalized Consultation\n- Resume Building\n- Interview Coaching\n- Quality Assurance Training\n- Programming Training",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Book Consultation Button
                          GestureDetector(
                            onTap: () {
                              // Action to book consultation
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Book Consultation @ 99/- only',
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
                ],
              ),
            ),
          ],
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

