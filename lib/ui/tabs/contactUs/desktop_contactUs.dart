import 'package:flutter/material.dart';
import 'contact_info_card.dart';
import '../../../data/tabs_layout.dart';

class DesktopContact extends StatelessWidget {
  const DesktopContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<int>(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tabBackgroundColors[4],
            tabGradientColors[4],
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 42, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First Card with constrained width
                  SizedBox(
                    width: 420,
                    height: 250,
                    child: ContactInfoCard(
                      name: 'ADMIN',
                      phone: '+91 8884741673',
                      email: 'consulting@eduvise.ai',
                      isDesktop: true,
                    ),
                  ),
                  // Second Card with same constrained width
                  SizedBox(
                    width: 400,
                    height: 250,
                    child: ContactInfoCard(
                      name: 'OFFICE',
                      phone: '+91 8050003203',
                      email: 'support@eduvise.ai',
                      isDesktop: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}