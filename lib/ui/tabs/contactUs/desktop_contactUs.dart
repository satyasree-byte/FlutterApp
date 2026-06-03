import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_info_card.dart';
import '../../../data/tabs_layout.dart';

class DesktopContact extends StatelessWidget {
  const DesktopContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Background glow orbs
          Positioned(top: -80, left: -100, child: _glowOrb(400, const Color(0xFF7C3AED))),
          Positioned(bottom: -60, right: -80, child: _glowOrb(350, const Color(0xFF0EA5E9))),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 100,
              left: 80, right: 80, bottom: 80,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Heading
                  _badge('Get In Touch'),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                          fontSize: 46, fontWeight: FontWeight.w900, color: Colors.white),
                      children: const [
                        TextSpan(text: 'We\'re Here to '),
                        TextSpan(
                          text: 'Help You',
                          style: TextStyle(color: Colors.amberAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Reach out to our team and we\'ll get back to you within 24 hours.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white60, fontSize: 17),
                  ),
                  const SizedBox(height: 60),

                  // Cards
                  Center(
                    child: SizedBox(
                      width: 480,
                      child: ContactInfoCard(
                        name: 'EDUVISE',
                        phone: '+91 9743997135',
                        email: 'consulting@eduvise.ai',
                        isDesktop: true,
                      ),
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

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.18),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: const Color(0xFFB794F4),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _glowOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.18), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}
