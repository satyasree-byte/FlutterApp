import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_services_data.dart';
import 'home_shared_widgets.dart';
import '../../../data/language_notifier.dart';

class DesktopHome extends StatefulWidget {
  const DesktopHome({Key? key}) : super(key: key);

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> with TickerProviderStateMixin {
  int _selected = 0;
  late AnimationController _heroCtrl;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late AnimationController _contentCtrl;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));
    _heroCtrl.forward();

    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));
    _contentCtrl.forward();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _selectService(int i) {
    if (i == _selected) return;
    setState(() => _selected = i);
    _contentCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final service = homeServices[_selected];

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Hero ──────────────────────────────────────────────
          ClipRect(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 72),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(top: -60, left: -80, child: _glowOrb(320, const Color(0xFF6C3AED))),
                  Positioned(bottom: -40, right: -60, child: _glowOrb(280, const Color(0xFF0EA5E9))),
                  FadeTransition(
                    opacity: _heroFade,
                    child: SlideTransition(
                      position: _heroSlide,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _urgencyBadge(),
                            const SizedBox(height: 24),
                          ValueListenableBuilder<bool>(
                            valueListenable: isHinglish,
                            builder: (_, hi, __) => Column(
                              children: [
                                Text(
                                  hi
                                      ? 'Career Guidance & AI Skills\nसही Experts से सीखो'
                                      : 'Expert Career Guidance\n& Real AI Skills — Online',
                                  textAlign: TextAlign.center,
                                  style: hi
                                      ? GoogleFonts.hindMadurai(
                                          fontSize: 52,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          height: 1.12,
                                        )
                                      : GoogleFonts.poppins(
                                          fontSize: 52,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          height: 1.12,
                                        ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  hi
                                      ? 'उन लोगों से बात करो जो यह कर चुके हैं. AI tools सीखो जो actually काम आते हैं.'
                                      : 'Talk to professionals who have done it. Learn AI tools that actually work.\nFor students, freshers, and working professionals.',
                                  textAlign: TextAlign.center,
                                  style: hi
                                      ? GoogleFonts.hindMadurai(color: Colors.white54, fontSize: 17)
                                      : GoogleFonts.poppins(color: Colors.white54, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),

          // ── Services section ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(80, 0, 80, 80),
            child: Column(
              children: [
                _sectionHeading('Our', 'Services'),
                const SizedBox(height: 36),

                // ── 4 service tiles ───────────────────────────
                Row(
                  children: List.generate(homeServices.length, (i) {
                    final s = homeServices[i];
                    final active = i == _selected;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < homeServices.length - 1 ? 18 : 0),
                        child: ServiceTile(
                          service: s,
                          active: active,
                          onTap: () => _selectService(i),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // ── Expanded content panel ────────────────────
                FadeTransition(
                  opacity: _contentFade,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: ContentPanel(service: service, isDesktop: true),
                  ),
                ),

                // ── Expert Card ───────────────────────────────
                const SizedBox(height: 72),
                const ExpertCard(isDesktop: true),

                // ── How It Works ──────────────────────────────
                const SizedBox(height: 72),
                const HowItWorksSection(isDesktop: true),

                // ── Free Resources ────────────────────────────
                const SizedBox(height: 72),
                const HomeResourcesSection(isDesktop: true),

                // ── AI Tools & Outcomes ───────────────────────
                const SizedBox(height: 72),
                const AiToolsSection(isDesktop: true),

                // ── CTA ───────────────────────────────────────
                const SizedBox(height: 56),
                const HomeCTABanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _urgencyBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withOpacity(0.12),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 7, height: 7,
                decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
            const SizedBox(width: 7),
            Text('Only $weeklySlots booking slots left this week',
                style: GoogleFonts.poppins(
                    color: const Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      );


  Widget _heroBadge(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
          ],
        ),
      );

  Widget _sectionHeading(String plain, String accent) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 38, fontWeight: FontWeight.w800, color: Colors.white),
          children: [
            TextSpan(text: '$plain '),
            TextSpan(text: accent, style: const TextStyle(color: Colors.amberAccent)),
          ],
        ),
      );

  Widget _glowOrb(double size, Color color) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color.withOpacity(0.22), color.withOpacity(0)]),
        ),
      );
}

