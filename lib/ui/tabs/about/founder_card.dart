import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants.dart';

class Founder {
  final String role;
  final String bio;
  final IconData icon;
  final Color color;

  const Founder({
    required this.role,
    required this.bio,
    this.icon = Icons.person_rounded,
    this.color = const Color(0xFF7C3AED),
  });
}

// TODO: populate when mentor profiles are ready to publish
final List<Founder> defaultFounders = [];

class FounderCard extends StatefulWidget {
  final Founder founder;
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;

  const FounderCard({
    Key? key,
    required this.founder,
    this.isDesktop = true,
    this.isTablet = true,
    this.isMobile = true,
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
    final f = widget.founder;

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
                ? [f.color.withOpacity(0.3), f.color.withOpacity(0.1)]
                : [Colors.blueGrey[900]!, Colors.blueGrey[800]!],
          ),
          border: Border.all(
            color: _isHovered ? f.color.withOpacity(0.6) : Colors.white.withOpacity(0.06),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.6 : 0.3),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: _isHovered ? 2 : 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isHovered ? 120 : 100,
              height: _isHovered ? 120 : 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: f.color.withOpacity(0.15),
                border: Border.all(
                  color: _isHovered ? f.color : Colors.grey[800]!,
                  width: _isHovered ? 3 : 2,
                ),
              ),
              child: Icon(f.icon, color: f.color, size: _isHovered ? 54 : 46),
            ),
            const SizedBox(height: 20),
            Text(
              f.role,
              style: GoogleFonts.poppins(
                fontSize: widget.isDesktop ? 20 : isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              f.bio,
              style: GoogleFonts.poppins(
                fontSize: widget.isDesktop ? 14 : isMobile ? 12 : 13,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
