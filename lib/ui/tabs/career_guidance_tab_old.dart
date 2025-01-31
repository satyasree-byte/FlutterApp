import 'package:flutter/material.dart';


class CareerGuidanceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.pink.shade800,
        image: DecorationImage(
          image: AssetImage('assets/images/career.png'),  // Transparent building image
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.pink.shade800.withOpacity(0.7),
            BlendMode.srcOver,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Left side: Video and Text
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video placeholder
                  Container(
                    height: 180,
                    color: Colors.grey.shade300,  // Placeholder for video
                    child: Center(
                      child: Icon(Icons.play_circle_fill, size: 50, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Career Guidance Text
                  Text(
                    "Career Guidance: Unlock your potential with expert advice on career paths, skill development, and more.",
                    style: TextStyle(
                      fontSize: 18, 
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            // Right side: Consultation Button
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action to book consultation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, 
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: Text(
                      "Book Consultation",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
