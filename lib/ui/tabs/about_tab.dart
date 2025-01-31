import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<int>(3),
       decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tabBackgroundColors[3],
            tabGradientColors[3],
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Text(
          'About Us Content Goes Here.',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
