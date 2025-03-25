// desktop_home.dart
import 'package:flutter/material.dart';
import '../services/bookServiceForm.dart';
import '../../utils/responsive_helper.dart';

class DesktopHome extends StatelessWidget {
  final TabController tabController;
  final Function(int) scrollToIndex;
  final List<GlobalKey> serviceKeys;

  DesktopHome({
    required this.tabController,
    required this.scrollToIndex,
    required this.serviceKeys,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          HeroSection(),
          Container(
            color: Colors.black.withOpacity(0.7),
            height: MediaQuery.of(context).size.height * 0.12,
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.normal,
              ),
              isScrollable: true,
              tabs: [
                Tab(text: 'High School Pathway Guidance'),
                Tab(text: 'University & College Advisory'),
                Tab(text: 'AI & Machine Learning Career Roadmap'),
                Tab(text: 'Quality Assurance Career Coaching'),
              ],
              onTap: (index) => scrollToIndex(index),
            ),
          ),
          Column(
            children: [
              _buildZigZagCard(
                'High School Pathway Guidance (Grades 8-12)',
                """
                How to use Artificial Intetelligence (AI) to improve your grades.
                Personalized help to choose the best career path after school.
                One-on-one programming lessons tailored to your child's needs.
                Clear explanations of tough topics in the syllabus.
                Quick doubt-solving to keep your child on track.
                Exam preparation plans to help your child do well.
                """,
                true,
                Colors.purple,
                key: serviceKeys[0],
              ),
              _buildZigZagCard(
                'University & College Advisory',
                """
                Personalized resume building.
                College project reviews to help land IT jobs.
                Mock interviews for freshers.
                Communication skills and presentation skills coaching.
                """,
                true,
                Colors.purple,
                key: serviceKeys[1],
              ),
              _buildZigZagCard(
                'AI & Machine Learning Career Roadmap',
                """Real-time project discussions to gain industry experience.
                Personalized resume review.
                Mock interviews to build confidence.
                Discussions on the latest tools and technologies in Data Science and Gen AI.
                """,
                false,
                Colors.purple,
                key: serviceKeys[2],
              ),
              _buildZigZagCard(
                'Quality Assurance Career Coaching',
                """Advanced QA tools from scratch.
                Personalized resume reviews.
                Technologies to consider in QA.
                Mock interview coaching.
                Real-time project discussions in QA.
                """,
                false,
                Colors.purple,
                key: serviceKeys[3],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZigZagCard(String title, String content, bool isLeftAligned, Color titleColor, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: isLeftAligned ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeftAligned) ...[
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
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0.2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getResponsiveImageSize(context, 250),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: _animation.value * 250,
            child: Center(
              child: Text(
                'Shape Your Future with Expert Guidance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 32),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          );
        },
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

class _ServiceCardState extends State<ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _flickerAnimation;
  
  late String _wordToFlicker;
  late Color _flickerColor;

  @override
  void initState() {
    super.initState();
    
    // Determine which word to flicker based on the card title
    if (widget.title.contains('High School')) {
      _wordToFlicker = 'Artificial Intetelligence (AI)';
      _flickerColor = Colors.white;
    } else if (widget.title.contains('University')) {
      _wordToFlicker = 'Personalized';
      _flickerColor = Colors.white;
    } else if (widget.title.contains('AI & Machine Learning')) {
      _wordToFlicker = 'Real-time project';
      _flickerColor = Colors.white;
    } else if (widget.title.contains('Quality Assurance')) {
      _wordToFlicker = 'Advanced QA';
      _flickerColor = Colors.white;
    } else {
      _wordToFlicker = '';
    }
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.001, end: 0.001).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
//book now flickering button
    _colorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _flickerAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveFontSize(context, 16)),
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: widget.titleColor,
            ),
          ),
          SizedBox(height: 10),
          _buildBulletPoints(context, widget.content),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..scale(_scaleAnimation.value)
                    ..rotateZ(_rotateAnimation.value),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingForm()),
                      );
                    },
                    child: Text(
                      "BOOK NOW",
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 25),
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        shadows: [
                          Shadow(
                            color: Colors.purple.withOpacity(0.5),
                            blurRadius: 3,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        ResponsiveHelper.getResponsiveImageSize(context, 180),
                        ResponsiveHelper.getResponsiveImageSize(context, 50),
                      ),
                      backgroundColor: _colorAnimation.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      elevation: 8,
                      shadowColor: Colors.greenAccent.withOpacity(0.7),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoints(BuildContext context, String content) {
    List<String> lines = content.trim().split("\n");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (_wordToFlicker.isNotEmpty && line.contains(_wordToFlicker)) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: ResponsiveHelper.getResponsiveFontSize(context, 20),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildFlickeringText(line),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: ResponsiveHelper.getResponsiveFontSize(context, 20),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    line.trim(),
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }).toList(),
    );
  }
  
//flickering text
  Widget _buildFlickeringText(String line) {
    List<String> parts = line.split(_wordToFlicker);
    
    return AnimatedBuilder(
      animation: _flickerAnimation,
      builder: (context, child) {
        return RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              color: Colors.white,
            ),
            children: [
              TextSpan(text: parts[0]),
              TextSpan(
                text: _wordToFlicker,
                style: TextStyle(
                  color: _flickerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
                  shadows: [
                    Shadow(
                      color: _flickerColor.withOpacity(0.3),
                      blurRadius: 20 * _flickerAnimation.value,
                    ),
                  ],
                  backgroundColor: Colors.purple.withOpacity(0.3 * _flickerAnimation.value),
                ),
              ),
              if (parts.length > 1) TextSpan(text: parts[1]),
            ],
          ),
        );
      },
    );
  }
}