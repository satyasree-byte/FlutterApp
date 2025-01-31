import 'package:flutter/material.dart';
import '../../data/tabs_layout.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
      key: ValueKey<int>(0),
       decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tabBackgroundColors[0],
            tabGradientColors[0],
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
