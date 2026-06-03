import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/tabs_layout.dart';

class AboutTab extends StatelessWidget {
  final List<Founder> founders = [
    Founder(
      role: 'Founder & CEO',
      icon: Icons.person_rounded,
      color: const Color(0xFF7C3AED),
      bio: 'AI Engineer with 11+ years of experience in software engineering, AI, and quality assurance.',
    ),
    Founder(
      role: 'Co-founder & CTO',
      icon: Icons.engineering_rounded,
      color: const Color(0xFF0EA5E9),
      bio: 'Tech specialist with expertise in cloud computing, cybersecurity, and scalable architectures.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        key: const ValueKey<int>(3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tabBackgroundColors[0], tabGradientColors[0]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0).add(const EdgeInsets.all(50.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    children: const [
                      TextSpan(text: 'Meet Our '),
                      TextSpan(
                        text: 'Team',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: founders.length,
                  itemBuilder: (context, index) => FounderCard(founder: founders[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Founder {
  final String role;
  final IconData icon;
  final Color color;
  final String bio;

  Founder({
    required this.role,
    required this.icon,
    required this.color,
    required this.bio,
  });
}

class FounderCard extends StatefulWidget {
  final Founder founder;
  const FounderCard({Key? key, required this.founder}) : super(key: key);

  @override
  _FounderCardState createState() => _FounderCardState();
}

class _FounderCardState extends State<FounderCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.founder;
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isHovered
                ? [f.color.withOpacity(0.3), f.color.withOpacity(0.1)]
                : [Colors.black54, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isHovered ? f.color.withOpacity(0.6) : Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: isHovered
              ? [BoxShadow(color: f.color.withOpacity(0.4), blurRadius: 20)]
              : [const BoxShadow(color: Colors.black45, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isHovered ? 100 : 88,
              height: isHovered ? 100 : 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: f.color.withOpacity(0.18),
                border: Border.all(color: f.color.withOpacity(0.5), width: 2),
              ),
              child: Icon(f.icon, color: f.color, size: isHovered ? 48 : 42),
            ),
            const SizedBox(height: 16),
            Text(
              f.role,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              f.bio,
              style: TextStyle(fontSize: 12, color: Colors.grey[400], fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
