import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/language_notifier.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isHinglish,
      builder: (_, hinglish, __) {
        return GestureDetector(
          onTap: () => isHinglish.value = !isHinglish.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: hinglish
                  ? const Color(0xFF7C3AED).withOpacity(0.25)
                  : Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: hinglish
                    ? const Color(0xFF7C3AED).withOpacity(0.7)
                    : Colors.white.withOpacity(0.18),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'EN',
                  style: GoogleFonts.poppins(
                    color: hinglish ? Colors.white38 : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text('·',
                      style: TextStyle(color: Colors.white24, fontSize: 11)),
                ),
                Text(
                  'HI',
                  style: GoogleFonts.poppins(
                    color: hinglish ? const Color(0xFFB794F4) : Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
