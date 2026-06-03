import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/mobile_home.dart';
import 'home/tablet_home.dart';
import 'home/desktop_home.dart';
import 'services/bookServiceForm.dart';

class responsive_Home extends StatelessWidget {
  const responsive_Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF060818), Color(0xFF0D1B2A), Color(0xFF0A0F1E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1100) {
              return const DesktopHome();
            } else if (constraints.maxWidth >= 700) {
              return const TabletHome();
            } else {
              return const MobileHome();
            }
          },
        ),
      ),

      // ── Sticky bottom CTA — mobile only ──────────────────────
      bottomNavigationBar: isMobile
          ? Container(
              decoration: BoxDecoration(
                color: const Color(0xFF060818).withOpacity(0.95),
                border: Border(
                  top: BorderSide(color: const Color(0xFF7C3AED).withOpacity(0.3), width: 1),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              child: SizedBox(
                height: 52,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookingForm()),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Book a Free Session',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
