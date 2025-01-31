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
        child: Text(
          'Contact Us Content Goes Here.',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
