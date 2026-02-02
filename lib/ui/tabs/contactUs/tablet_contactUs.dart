// lib/ui/tabs/contact/tablet_contact.dart
import 'package:flutter/material.dart';
import 'contact_info_card.dart';
import '../../../data/tabs_layout.dart';

class TabletContact extends StatelessWidget {
  const TabletContact({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Contact Us',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 32, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ContactInfoCard(
                  name: 'ADMIN',
                  phone: '+91 8884741673',
                  email: 'consulting@eduvise.ai',
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: ContactInfoCard(
                  name: 'OFFICE',
                  phone: '+91 8050003203',
                  email: 'support@eduvise.ai',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}