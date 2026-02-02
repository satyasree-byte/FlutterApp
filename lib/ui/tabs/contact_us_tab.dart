import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';

class ContactUsTab extends StatelessWidget {
  const ContactUsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<int>(4),
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ContactInfoCard(
              name: 'ADMIN',
              phone: '+91 8884741673',
              email: 'consulting@eduvise.ai',
            ),
            SizedBox(height: 20),
            ContactInfoCard(
              name: 'OFFICE',
              phone: '+91 8050003203',
              email: 'support@eduvise.ai',
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;

  const ContactInfoCard({
    required this.name,
    required this.phone,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: $phone',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}