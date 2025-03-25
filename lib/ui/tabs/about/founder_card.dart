// lib/ui/tabs/about/founder_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants.dart';

class Founder {
  final String name;
  final String role;
  final String imageUrl;
  final String linkedinUrl;
  final String bio;

  const Founder({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.linkedinUrl,
    required this.bio,
  });
}

final List<Founder> defaultFounders = [
  Founder(
    name: "Akash Kumar",
    role: "Founder & CEO",
    imageUrl: "assets/images/Founder.jpeg",
    linkedinUrl: "https://www.linkedin.com/in/akash-kumar-silicon",
    bio: "AI Engineer with 11+ years of experience in software engineering, AI, and quality assurance.",
  ),
  Founder(
    name: "Satya sree",
    role: "Co-founder & CTO",
    imageUrl: "assets/images/Founder2.jpeg",
    linkedinUrl: "https://www.linkedin.com/in/satyasree-annapragada/",
    bio: "Tech enthusiast with expertise in cloud computing, cybersecurity, and scalable architectures.",
  ),
];

class FounderCard extends StatefulWidget {
  final Founder founder;
  final bool isDesktop;
  final bool isTablet;
  
  const FounderCard({
    Key? key, 
    required this.founder,
    this.isDesktop = false,
    this.isTablet = false,
  }) : super(key: key);

  @override
  _FounderCardState createState() => _FounderCardState();
}

class _FounderCardState extends State<FounderCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < ScreenSize.tablet;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isDesktop ? 300 : widget.isTablet ? null : double.infinity,
        margin: EdgeInsets.all(isMobile ? 8 : 16),
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isHovered 
                ? [Colors.blueAccent.withOpacity(0.7), Colors.blueAccent.withOpacity(0.3)]
                : [Colors.blueGrey[900]!, Colors.blueGrey[800]!],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.6 : 0.3),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: _isHovered ? 2 : 1,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isHovered ? 130 : 110,
              height: _isHovered ? 130 : 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isHovered ? Colors.white : Colors.grey[800]!,
                  width: _isHovered ? 4 : 2,
                ),
                image: DecorationImage(
                  image: AssetImage(widget.founder.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.founder.name,
              style: GoogleFonts.poppins(
                fontSize: widget.isDesktop ? 24 : isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.founder.role,
              style: GoogleFonts.poppins(
                fontSize: widget.isDesktop ? 18 : isMobile ? 14 : 16,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.founder.bio,
              style: GoogleFonts.poppins(
                fontSize: widget.isDesktop ? 16 : isMobile ? 12 : 14,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.linkedin,
                color: _isHovered ? Colors.blueAccent : Colors.grey[400],
                size: widget.isDesktop ? 32 : 28,
              ),
              onPressed: () => _launchURL(widget.founder.linkedinUrl),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }
}