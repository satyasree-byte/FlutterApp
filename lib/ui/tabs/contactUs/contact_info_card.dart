import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bookServiceForm.dart';

class ContactInfoCard extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final bool isMobile;
  final bool isDesktop;

  const ContactInfoCard({
    required this.name,
    required this.phone,
    required this.email,
    this.isMobile = false,
    this.isDesktop = false,
    Key? key,
  }) : super(key: key);

  @override
  _ContactInfoCardState createState() => _ContactInfoCardState();
}

class _ContactInfoCardState extends State<ContactInfoCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get _accent =>
      widget.name == 'ADMIN' ? const Color(0xFF7C3AED) : const Color(0xFF0EA5E9);

  IconData get _icon =>
      widget.name == 'ADMIN' ? Icons.admin_panel_settings_rounded : Icons.business_rounded;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(widget.isDesktop ? 32 : widget.isMobile ? 20 : 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: _hovered
                    ? [_accent.withOpacity(0.28), _accent.withOpacity(0.1)]
                    : [Colors.white.withOpacity(0.07), Colors.white.withOpacity(0.03)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _hovered ? _accent.withOpacity(0.7) : Colors.white.withOpacity(0.12),
                width: 1.5,
              ),
              boxShadow: _hovered
                  ? [BoxShadow(color: _accent.withOpacity(0.3), blurRadius: 32, offset: const Offset(0, 10))]
                  : [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon badge
                Container(
                  width: widget.isDesktop ? 64 : 52,
                  height: widget.isDesktop ? 64 : 52,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: _accent.withOpacity(0.4)),
                  ),
                  child: Icon(_icon, color: _accent, size: widget.isDesktop ? 30 : 24),
                ),
                SizedBox(height: widget.isDesktop ? 20 : 14),
                // Name
                Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                    fontSize: widget.isDesktop ? 22 : widget.isMobile ? 17 : 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: widget.isDesktop ? 20 : 14),
                // Divider
                Container(height: 1, color: Colors.white.withOpacity(0.1)),
                SizedBox(height: widget.isDesktop ? 18 : 12),
                // Phone
                _infoRow(Icons.phone_rounded, widget.phone, widget.isDesktop, widget.isMobile),
                const SizedBox(height: 10),
                // Email
                _infoRow(Icons.mail_rounded, widget.email, widget.isDesktop, widget.isMobile),
                SizedBox(height: widget.isDesktop ? 24 : 18),
                // CTA button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: widget.isDesktop ? 16 : 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: _hovered ? 8 : 2,
                      shadowColor: _accent.withOpacity(0.5),
                      textStyle: GoogleFonts.poppins(
                          fontSize: widget.isDesktop ? 15 : 13,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookingForm()),
                    ),
                    icon: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: const Text('Book a Session'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, bool isDesktop, bool isMobile) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied: $text', style: GoogleFonts.poppins()),
            backgroundColor: _accent,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _accent, size: isDesktop ? 18 : 15),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: isDesktop ? 15 : isMobile ? 13 : 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
