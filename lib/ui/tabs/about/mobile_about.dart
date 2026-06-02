// lib/ui/tabs/about/mobile_about.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'founder_card.dart';
import '../../../constants.dart';

class MobileAbout extends StatelessWidget {
  final List<Founder> founders;

  const MobileAbout({Key? key, required this.founders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 80,
          left: 16,
          right: 16,
          bottom: 40,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: const [
                    TextSpan(text: 'Meet Our '),
                    TextSpan(
                      text: 'Mentors',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: founders.map((founder) => FounderCard(
                founder: founder,
                isDesktop: false,
                isTablet: false,
                isMobile: true,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}