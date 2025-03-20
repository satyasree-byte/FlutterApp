import 'package:flutter/material.dart';
import 'services/bookServiceForm.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _serviceKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    Scrollable.ensureVisible(
      _serviceKeys[index].currentContext!,
      duration: Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/tech.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Hero Section
              HeroSection(),

              // TabBar
              Container(
                color: Colors.black.withOpacity(0.7), // Semi-transparent background for tabs
                height: MediaQuery.of(context).size.height * 0.12, // Fixed width
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.green, // Tab indicator color
                  labelColor: Colors.green, // Selected tab text color
                  unselectedLabelColor: Colors.white, // Unselected tab text color
 
                  labelStyle: TextStyle(
                    fontSize: 18, // Font size for selected tabs
                    fontWeight: FontWeight.bold, // Bold text for selected tabs
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16, // Font size for unselected tabs
                    fontWeight: FontWeight.normal, // Normal text for unselected tabs
                  ),
                  isScrollable: true, 
                  tabs: [
                    _buildTab('High School Pathway Guidance', 0),
                    _buildTab('University & College Advisory', 1),
                    _buildTab('AI & Machine Learning Career Roadmap', 2),
                    _buildTab('Quality Assurance Career Coaching', 3),
                  ],
                  onTap: (index) {
                    _scrollToIndex(index); // Scroll to the respective section
                  },
                ),
              ),

              // Service Cards Section
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 1.0,
                ),
                child: Column(
                  children: [
                    _buildZigZagCard(
                      'High School Pathway Guidance (Grades 8-12)',
                      """
                      Personalized help to choose the best career path after school.
                      One-on-one programming lessons tailored to your child’s needs.
                      Clear explanations of tough topics in the syllabus.
                      Quick doubt-solving to keep your child on track.
                      Exam preparation plans to help your child do well.
                      """,
                      true, // Left aligned
                      Colors.purple, // Title color
                      key: _serviceKeys[0], // Key for scrolling
                    ),
                    _buildZigZagCard(
                      'University & College Advisory',
                      """
                      Personalized resume building.
                      College project reviews to help land IT jobs.
                      Mock interviews for freshers.
                      Communication skills and presentation skills coaching.
                      """,
                      true, // Left aligned
                      Colors.purple, // Title color
                      key: _serviceKeys[1], // Key for scrolling
                    ),
                    _buildZigZagCard(
                      'AI & Machine Learning Career Roadmap',
                      """
                      Personalized resume review.
                      Mock interviews to build confidence.
                      Discussions on the latest tools and technologies in Data Science and Gen AI.
                      Real-time project discussions to gain industry experience.
                      """,
                      false, // Right aligned
                      Colors.purple, // Title color
                      key: _serviceKeys[2], // Key for scrolling
                    ),
                    _buildZigZagCard(
                      'Quality Assurance Career Coaching',
                      """
                      Personalized resume reviews.
                      Technologies to consider in QA.
                      Mock interview coaching.
                      Real-time project discussions in QA.
                      """,
                      false, // Right aligned
                      Colors.purple, // Title color
                      key: _serviceKeys[3], // Key for scrolling
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return MouseRegion(
      onEnter: (_) => setState(() => _tabController.index = index), // Hover effect
      child: Tab(
        text: text,
      ),
    );
  }

  Widget _buildZigZagCard(String title, String content, bool isLeftAligned, Color titleColor, {Key? key}) {
    return Padding(
      key: key, // Key for scrolling
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: isLeftAligned
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (isLeftAligned) ...[
            // Left-aligned content
            Expanded(
              child: ServiceCard(
                title: title,
                content: content,
                isLeftAligned: isLeftAligned,
                titleColor: titleColor,
              ),
            ),
            SizedBox(width: 16),
          ] else ...[
            // Right-aligned content
            SizedBox(width: 16),
            Expanded(
              child: ServiceCard(
                title: title,
                content: content,
                isLeftAligned: isLeftAligned,
                titleColor: titleColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HeroSection extends StatefulWidget {
  @override
  _HeroSectionState createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Animation duration
      vsync: this,
    );

    // Define the animation
    _animation = Tween<Offset>(
      begin: Offset(0, 1), // Start from below the screen
      end: Offset(0, 0.2), // End at the final position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Smooth easing curve
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // Adjusted height
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: _animation.value * 250, // Adjust the offset based on animation value
            child: Center(
              child: Text(
                'Shape Your Future with Expert Guidance',
                textAlign: TextAlign.center, // Center-align the text
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.1), // Semi-transparent background
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String content;
  final bool isLeftAligned;
  final Color titleColor;

  const ServiceCard({
    required this.title,
    required this.content,
    required this.isLeftAligned,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * 0.45, // Fixed width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.7), // Semi-transparent background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor, // Custom title color
            ),
          ),
          SizedBox(height: 10),
          _buildBulletPoints(content),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingForm()),
                );
              },
              child: Text("Book Now"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(180, 50), // Larger button size
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoints(String content) {
    List<String> lines = content.trim().split("\n");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green, // Green tick mark
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                line.trim(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}