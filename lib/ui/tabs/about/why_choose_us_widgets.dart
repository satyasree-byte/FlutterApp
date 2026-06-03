import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'why_choose_us_data.dart';

// ---------- Animated stat counter ----------
class AnimatedStatCard extends StatefulWidget {
  final StatItem stat;
  final double size;
  const AnimatedStatCard({Key? key, required this.stat, required this.size}) : super(key: key);

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: s,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.stat.icon, color: Colors.amberAccent, size: s * 0.22),
              const SizedBox(height: 10),
              Text(
                widget.stat.value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: s * 0.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.stat.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: s * 0.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Reason card ----------
class ReasonCard extends StatefulWidget {
  final ReasonItem reason;
  final bool isDesktop;
  const ReasonCard({Key? key, required this.reason, this.isDesktop = false}) : super(key: key);

  @override
  State<ReasonCard> createState() => _ReasonCardState();
}

class _ReasonCardState extends State<ReasonCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.reason.color.withOpacity(0.22)
              : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? widget.reason.color.withOpacity(0.7)
                : Colors.white.withOpacity(0.12),
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: widget.reason.color.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.reason.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.reason.icon, color: widget.reason.color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              widget.reason.title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: widget.isDesktop ? 18 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.reason.description,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: widget.isDesktop ? 14 : 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Section heading ----------
Widget sectionHeading(String plain, String accent, {double fontSize = 32}) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.w800, color: Colors.white),
      children: [
        TextSpan(text: '$plain '),
        TextSpan(
          text: accent,
          style: const TextStyle(color: Colors.amberAccent),
        ),
      ],
    ),
  );
}
