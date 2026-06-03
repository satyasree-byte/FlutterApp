import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'why_choose_us_data.dart';
import 'why_choose_us_widgets.dart';
import '../services/bookServiceForm.dart';

class TabletWhyChooseUs extends StatelessWidget {
  const TabletWhyChooseUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 100,
          left: 40,
          right: 40,
          bottom: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sectionHeading('Why Choose', 'Eduvise?', fontSize: 36),
            const SizedBox(height: 10),
            Text(
              'Talk to a real expert. Learn AI that works. Get clear direction — fast.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15),
            ),

            // Stats 2x2
            const SizedBox(height: 48),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: whyChooseStats.length,
              itemBuilder: (_, i) => AnimatedStatCard(stat: whyChooseStats[i], size: 130),
            ),

            const SizedBox(height: 56),
            sectionHeading('What Makes Us', 'Different?', fontSize: 28),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.0,
              ),
              itemCount: whyChooseReasons.length,
              itemBuilder: (_, i) => ReasonCard(reason: whyChooseReasons[i]),
            ),

            const SizedBox(height: 48),
            _CtaBannerTablet(),
          ],
        ),
      ),
    );
  }
}

class _CtaBannerTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Still unsure? One conversation is all it takes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'No commitment. No pressure. Just a real expert who can help you figure out your next step.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              textStyle:
                  GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingForm())),
            child: const Text('Book a Free Session →'),
          ),
        ],
      ),
    );
  }
}
