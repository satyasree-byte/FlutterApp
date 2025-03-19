import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';
import 'services/bookServiceForm.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<int>(0),
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
            // Hero Section
            HeroSection(),

            // Service Cards Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Service Cards with Zig-Zag Pattern
                  _buildZigZagCard(
                    'Software Career Guidance for 10th & 12th Students',
                    """
                    Personalized help to choose the best career path after school.
                    One-on-one programming lessons tailored to your child’s needs.
                    Clear explanations of tough topics in the syllabus.
                    Quick doubt-solving to keep your child on track.
                    Exam preparation plans to help your child do well.
                    """,
                    true, // Left aligned
                    Colors.purple, // Title color
                  ),
                  _buildZigZagCard(
                    'Career Transition to Data Science & Gen AI for Professionals',
                    """
                    Personalized resume review.
                    Mock interviews to build confidence.
                    Discussions on the latest tools and technologies in Data Science and Gen AI.
                    Real-time project discussions to gain industry experience.
                    """,
                    false, // Right aligned
                    Colors.purple, // Title color
                  ),
                  _buildZigZagCard(
                    'Guidance for College Students in Gen AI Careers',
                    """
                    Personalized resume building.
                    College project reviews to help land IT jobs.
                    Mock interviews for freshers.
                    Communication skills and presentation skills coaching.
                    """,
                    true, // Left aligned
                    Colors.purple, // Title color
                  ),
                  _buildZigZagCard(
                    'Quality Assurance Career Path for Professionals',
                    """
                    Personalized resume reviews.
                    Technologies to consider in QA.
                    Mock interview coaching.
                    Real-time project discussions in QA.
                    """,
                    false, // Right aligned
                    Colors.purple, // Title color
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZigZagCard(String title, String content, bool isLeftAligned, Color titleColor) {
    return Padding(
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

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/tech.jpg'), // Your image asset
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'Shape Your Future with Expert Guidance',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
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
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isHovered = false;
  bool _isTitleHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 20),
        width: _isHovered ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.45, // Increased width on hover
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent, // Transparent background
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: widget.isLeftAligned
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (widget.isLeftAligned) ...[
              // Content on Left
              Expanded(
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isTitleHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isTitleHovered = false;
                    });
                  },
                  child: AnimatedOpacity(
                    opacity: _isHovered || _isTitleHovered ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black, // Set the color of the content section
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: widget.titleColor, // Custom title color
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildBulletPoints(widget.content),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {  
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => BookingForm()));
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
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
            ] else ...[
              // Content on Right
              SizedBox(width: 16),
              Expanded(
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isTitleHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isTitleHovered = false;
                    });
                  },
                  child: AnimatedOpacity(
                    opacity: _isHovered || _isTitleHovered ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: widget.titleColor, // Custom title color
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildBulletPoints(widget.content),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => BookingForm()));
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
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
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
