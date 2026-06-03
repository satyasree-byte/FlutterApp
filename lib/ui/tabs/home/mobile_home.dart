import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_services_data.dart';
import 'home_shared_widgets.dart';
import '../../../data/language_notifier.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({Key? key}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> with TickerProviderStateMixin {
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
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
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
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 22),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(top: -30, left: -40, child: _glowOrb(160, const Color(0xFF6C3AED))),
                  Positioned(bottom: -20, right: -30, child: _glowOrb(130, const Color(0xFF0EA5E9))),
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
                            const SizedBox(height: 14),
                            ValueListenableBuilder<bool>(
                              valueListenable: isHinglish,
                              builder: (_, hi, __) => Column(
                                children: [
                                  Text(
                                    hi
                                        ? 'Career Guidance\n& AI Skills — सही तरीके से'
                                        : 'Career Guidance\n& AI Skills Online',
                                    textAlign: TextAlign.center,
                                    style: hi
                                        ? GoogleFonts.hindMadurai(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            height: 1.2,
                                          )
                                        : GoogleFonts.poppins(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            height: 1.2,
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    hi
                                        ? 'असली experts से बात करो. AI सीखो जो काम आए. Students, freshers & professionals के लिए.'
                                        : 'Talk to real experts. Learn AI that actually works. Students, freshers & working professionals.',
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
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 50),
            child: Column(
              children: [
                _sectionHeading('Our', 'Services'),
                const SizedBox(height: 22),

                // 2x2 grid of tiles
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: homeServices.length,
                  itemBuilder: (_, i) => _MobileTile(
                    service: homeServices[i],
                    active: i == _selected,
                    onTap: () => _selectService(i),
                  ),
                ),

                const SizedBox(height: 18),

                // Content panel
                FadeTransition(
                  opacity: _contentFade,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: ContentPanel(service: service),
                  ),
                ),

                const SizedBox(height: 40),
                const ExpertCard(),

                const SizedBox(height: 40),
                const HowItWorksSection(),

                const SizedBox(height: 40),
                const HomeResourcesSection(),

                const SizedBox(height: 40),
                const AiToolsSection(),

                const SizedBox(height: 36),
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


  Widget _sectionHeading(String plain, String accent) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
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

// Compact tile for mobile
class _MobileTile extends StatelessWidget {
  final ServiceData service;
  final bool active;
  final VoidCallback onTap;
  const _MobileTile({required this.service, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = service;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active ? s.color.withOpacity(0.18) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? s.color.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            width: active ? 2 : 1,
          ),
          boxShadow: active
              ? [BoxShadow(color: s.color.withOpacity(0.28), blurRadius: 20, offset: const Offset(0, 6))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: s.color.withOpacity(active ? 0.25 : 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(s.icon, color: s.color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(s.title,
                maxLines: 2,
                style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(
              active ? 'Selected ✓' : 'Tap →',
              style: GoogleFonts.poppins(
                color: active ? s.color : Colors.white30,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
