import 'package:flutter/material.dart';
import 'contact_info_card.dart';
import '../../../data/tabs_layout.dart';

class MobileContact extends StatelessWidget {
  const MobileContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ContactInfoCard(
                          name: 'ADMIN',
                          phone: '+91 8884741673',
                          email: 'consultation@eduvise.ai',
                          isMobile: true,
                        ),
                        const SizedBox(height: 20),
                        ContactInfoCard(
                          name: 'OFFICE',
                          phone: '+91 8050003203',
                          email: 'support@eduvise.ai',
                          isMobile: true,
                        ),
                        const SizedBox(height: 20), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}