import 'package:flutter/material.dart';
import '../services/bookServiceForm.dart';
import '../../utils/responsive_helper.dart';

class MobileHome extends StatelessWidget {
  final TabController tabController;
  final Function(int) scrollToIndex;
  final List<GlobalKey> serviceKeys;

  MobileHome({
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
            color: Colors.black.withOpacity(0.75),
            height: MediaQuery.of(context).size.height * 0.07,
            child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: tabController,
              indicatorColor: const Color(0xFF64FFDA),
              indicatorWeight: 3,
              labelColor: const Color(0xFF64FFDA),
              unselectedLabelColor: Colors.white70,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 15),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.w500,
              ),
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.only(left: 8),
              tabs: [
                Tab(text: 'High School'),
                Tab(text: 'University'),
                Tab(text: 'AI & ML'),
                Tab(text: 'QA'),
              ],
              onTap: (index) => scrollToIndex(index),
            ),
          ),
          ),
          Column(
            children: [
              _buildZigZagCard(
                'High School Pathway Guidance (Grades 8-12)',
                """AI-powered grade improvement.
                Career path clarity after school.
                Exam strategy & doubt solving.""",
                true,
                Colors.tealAccent,
                key: serviceKeys[0],
              ),
              _buildZigZagCard(
                'University & College Advisory',
                """Job-ready resume building.
                Real project reviews for IT roles.
                Mock interviews & communication coaching.""",
                true,
                Colors.amberAccent,
                key: serviceKeys[1],
              ),
              _buildZigZagCard(
                'AI & Machine Learning Career Roadmap',
                """Hands-on GenAI & Data Science projects.
                Resume review + mock interviews.
                Latest tools: LLMs, MLOps & more.""",
                true,
                Colors.cyanAccent,
                key: serviceKeys[2],
              ),
              _buildZigZagCard(
                'Quality Assurance Career Coaching',
                """QA automation tools from scratch.
                Resume review & mock interviews.
                Real-time QA project experience.""",
                true,
                Colors.greenAccent,
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ServiceCard(
        title: title,
        content: content,
        isLeftAligned: isLeftAligned,
        titleColor: titleColor,
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
      height: ResponsiveHelper.getResponsiveImageSize(context, 240),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: _animation.value * 240,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.65),
                      const Color(0xFF0A2818).withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF64FFDA).withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Shape Your Future',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 26),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: const Color(0xFF64FFDA).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'with Expert Guidance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64FFDA),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
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
    
    if (widget.title.contains('High School')) {
      _wordToFlicker = 'AI-powered';
      _flickerColor = Colors.tealAccent;
    } else if (widget.title.contains('University')) {
      _wordToFlicker = 'Job-ready';
      _flickerColor = Colors.amberAccent;
    } else if (widget.title.contains('AI & Machine Learning')) {
      _wordToFlicker = 'Hands-on GenAI';
      _flickerColor = Colors.cyanAccent;
    } else if (widget.title.contains('Quality Assurance')) {
      _wordToFlicker = 'QA automation';
      _flickerColor = Colors.greenAccent;
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

    _colorAnimation = ColorTween(
      begin: const Color(0xFF0A1628),
      end: const Color(0xFF00897B),
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
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveFontSize(context, 18)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.82),
            const Color(0xFF0A1F14).withOpacity(0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: widget.titleColor.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.titleColor.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: widget.titleColor,
              letterSpacing: 0.3,
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
                      "CONNECT",
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.5,
                        shadows: [
                          Shadow(
                            color: const Color(0xFF64FFDA).withOpacity(0.8),
                            blurRadius: 8,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        ResponsiveHelper.getResponsiveImageSize(context, 140),
                        ResponsiveHelper.getResponsiveImageSize(context, 44),
                      ),
                      backgroundColor: _colorAnimation.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: const Color(0xFF64FFDA),
                          width: 1.5,
                        ),
                      ),
                      elevation: 12,
                      shadowColor: const Color(0xFF00BFA5).withOpacity(0.6),
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
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: _flickerColor,
                    size: ResponsiveHelper.getResponsiveFontSize(context, 16),
                  ),
                ),
                const SizedBox(width: 10),
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
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: _flickerColor.withOpacity(0.7),
                    size: ResponsiveHelper.getResponsiveFontSize(context, 16),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    line.trim(),
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 15),
                      color: Colors.white.withOpacity(0.92),
                      height: 1.4,
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
  
  Widget _buildFlickeringText(String line) {
    List<String> parts = line.split(_wordToFlicker);
    
    return AnimatedBuilder(
      animation: _flickerAnimation,
      builder: (context, child) {
        return RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              color: Colors.white,
            ),
            children: [
              TextSpan(text: parts[0]),
              TextSpan(
                text: _wordToFlicker,
                style: TextStyle(
                  color: _flickerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                  shadows: [
                    Shadow(
                      color: _flickerColor.withOpacity(0.3),
                      blurRadius: 20 * _flickerAnimation.value,
                    ),
                  ],
                  backgroundColor: _flickerColor.withOpacity(0.15 * _flickerAnimation.value),
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