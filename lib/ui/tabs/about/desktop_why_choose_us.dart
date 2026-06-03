import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'why_choose_us_data.dart';
import 'why_choose_us_widgets.dart';
import '../services/bookServiceForm.dart';

class DesktopWhyChooseUs extends StatelessWidget {
  const DesktopWhyChooseUs({Key? key}) : super(key: key);

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
          left: 80,
          right: 80,
          bottom: 80,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero heading
              sectionHeading('Why Choose', 'Eduvise?', fontSize: 46),
              const SizedBox(height: 12),
              Text(
                'Talk to a real expert. Learn AI that works. Get clear direction — fast.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 18),
              ),

              // Stats row
              const SizedBox(height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: whyChooseStats
                    .map((s) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: AnimatedStatCard(stat: s, size: 160),
                        ))
                    .toList(),
              ),

              // Reasons grid
              const SizedBox(height: 72),
              sectionHeading('What Makes Us', 'Different?', fontSize: 36),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.1,
                ),
                itemCount: whyChooseReasons.length,
                itemBuilder: (_, i) => ReasonCard(reason: whyChooseReasons[i], isDesktop: true),
              ),

              // CTA
              const SizedBox(height: 72),
              _CtaBanner(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'Still unsure? One conversation is all it takes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'No commitment. No pressure. Just a real expert who can help you figure out your next step.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingForm())),
            child: const Text('Book a Free Session →'),
          ),
        ],
      ),
    );
  }
}
