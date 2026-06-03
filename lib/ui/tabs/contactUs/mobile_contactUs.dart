import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_info_card.dart';
import '../../../data/tabs_layout.dart';

class MobileContact extends StatelessWidget {
  const MobileContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: const ValueKey<int>(4),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF060818), Color(0xFF0D1B2A), Color(0xFF0A0F1E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -40, left: -50, child: _glowOrb(200, const Color(0xFF7C3AED))),
            Positioned(bottom: -30, right: -40, child: _glowOrb(160, const Color(0xFF0EA5E9))),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _badge('Get In Touch'),
                    const SizedBox(height: 14),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                            fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                        children: const [
                          TextSpan(text: 'We\'re Here\nto '),
                          TextSpan(
                            text: 'Help You',
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We\'ll get back to you within 24 hours.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
                    ),
                    const SizedBox(height: 36),
                    ContactInfoCard(
                      name: 'EDUVISE',
                      phone: '+91 9743997135',
                      email: 'consulting@eduvise.ai',
                      isMobile: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.18),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: const Color(0xFFB794F4),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _glowOrb(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.18), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}
