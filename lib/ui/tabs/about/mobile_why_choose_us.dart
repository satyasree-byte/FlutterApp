import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'why_choose_us_data.dart';
import 'why_choose_us_widgets.dart';
import '../services/bookServiceForm.dart';

class MobileWhyChooseUs extends StatelessWidget {
  const MobileWhyChooseUs({Key? key}) : super(key: key);

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
          top: MediaQuery.of(context).padding.top + 90,
          left: 18,
          right: 18,
          bottom: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sectionHeading('Why Choose', 'Eduvise?', fontSize: 26),
            const SizedBox(height: 8),
            Text(
              'Talk to a real expert. Learn AI that works. Get clear direction — fast.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
            ),

            // Stats 2x2
            const SizedBox(height: 36),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: whyChooseStats.length,
              itemBuilder: (_, i) => AnimatedStatCard(stat: whyChooseStats[i], size: 110),
            ),

            const SizedBox(height: 48),
            sectionHeading('What Makes Us', 'Different?', fontSize: 22),
            const SizedBox(height: 20),
            ...whyChooseReasons.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: ReasonCard(reason: r),
                )),

            const SizedBox(height: 40),
            _CtaBannerMobile(),
          ],
        ),
      ),
    );
  }
}

class _CtaBannerMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            'Still unsure? One conversation is all it takes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'No commitment. No pressure. Just a real expert who can help you figure out your next step.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              textStyle:
                  GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingForm())),
            child: const Text('Book a Free Session →'),
          ),
        ],
      ),
    );
  }
}
