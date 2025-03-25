// lib/ui/tabs/about/desktop_about.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'founder_card.dart';
import '../../../constants.dart';
import '../../../data/tabs_layout.dart';

class DesktopAbout extends StatelessWidget {
  final List<Founder> founders;

  const DesktopAbout({Key? key, required this.founders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 140,
          left: 80,
          right: 80,
          bottom: 80,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
            Colors.purple,
             Colors.green
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: const [
                  TextSpan(text: 'Meet Our '),
                  TextSpan(
                    text: 'Founders',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: founders.map((founder) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FounderCard(
                    founder: founder,
                    isDesktop: true,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}