import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_services_data.dart';
import 'home_shared_widgets.dart';
import '../../../data/language_notifier.dart';

class TabletHome extends StatefulWidget {
  const TabletHome({Key? key}) : super(key: key);

  @override
  State<TabletHome> createState() => _TabletHomeState();
}

class _TabletHomeState extends State<TabletHome> with TickerProviderStateMixin {
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
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));
    _heroCtrl.forward();

    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
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
              padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(top: -40, left: -60, child: _glowOrb(240, const Color(0xFF6C3AED))),
                  Positioned(bottom: -30, right: -40, child: _glowOrb(200, const Color(0xFF0EA5E9))),
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
                            const SizedBox(height: 18),
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
                                            fontSize: 34,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            height: 1.15,
                                          )
                                        : GoogleFonts.poppins(
                                            fontSize: 34,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            height: 1.15,
                                          ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    hi
                                        ? 'उन लोगों से बात करो जो यह कर चुके हैं. AI tools सीखो जो actually काम आते हैं.'
                                        : 'Talk to professionals who have done it. Learn AI tools that actually work. For students, freshers & working professionals.',
                                    textAlign: TextAlign.center,
                                    style: hi
                                        ? GoogleFonts.hindMadurai(color: Colors.white54, fontSize: 13)
                                        : GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
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
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 60),
            child: Column(
              children: [
                _sectionHeading('Our', 'Services'),
                const SizedBox(height: 28),

                // 2x2 grid of tiles
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: homeServices.length,
                  itemBuilder: (_, i) => ServiceTile(
                    service: homeServices[i],
                    active: i == _selected,
                    onTap: () => _selectService(i),
                  ),
                ),

                const SizedBox(height: 20),

                // Content panel
                FadeTransition(
                  opacity: _contentFade,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: ContentPanel(service: service),
                  ),
                ),

                const SizedBox(height: 56),
                const ExpertCard(),

                const SizedBox(height: 56),
                const HowItWorksSection(),

                const SizedBox(height: 56),
                const HomeResourcesSection(),

                const SizedBox(height: 56),
                const AiToolsSection(),

                const SizedBox(height: 48),
                const HomeCTABanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _urgencyBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withOpacity(0.12),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6,
                decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text('Only $weeklySlots slots left this week',
                style: GoogleFonts.poppins(
                    color: const Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _heroBadge(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
          ],
        ),
      );

  Widget _sectionHeading(String plain, String accent) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
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
          gradient: RadialGradient(colors: [color.withOpacity(0.2), color.withOpacity(0)]),
        ),
      );
}
