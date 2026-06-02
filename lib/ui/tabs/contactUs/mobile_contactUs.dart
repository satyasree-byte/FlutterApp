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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 360 ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  ContactInfoCard(
                    name: 'ADMIN',
                    phone: '+91 9743997135',
                    email: 'consulting@eduvise.ai',
                    isMobile: true,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  ContactInfoCard(
                    name: 'OFFICE',
                    phone: '+91 9743997135',
                    email: 'support@eduvise.ai',
                    isMobile: true,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}