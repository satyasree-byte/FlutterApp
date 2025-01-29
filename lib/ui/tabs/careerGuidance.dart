import 'package:flutter/material.dart';

class CareerGuidancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Career Guidance')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Career Guidance for Software Industry
            Text(
              'Career Guidance for Software Industry',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              'The software industry is rapidly growing, and the opportunities are endless for those with the right skills. Whether you\'re aiming to become a software developer, data scientist, UX designer, or project manager, understanding the tech landscape is crucial. Our expert guidance will help you identify the skills you need, navigate the job market, and accelerate your career.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 30),

            // Career Guidance for Schools/Colleges
            Text(
              'Career Guidance for Schools/Colleges',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              'Starting your career journey as a student can feel overwhelming, but with the right guidance, you can make informed decisions that set you up for success. Whether you\'re still in school or finishing college, we provide personalized career advice that helps you choose the right path based on your strengths, interests, and long-term goals.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 30),

            // Founder Quote Section
            Row(
              children: [
                // Founder Image
                ClipOval(
                  child: Image.asset(
                    'assets/images/founder.jpg', // Replace with your image path
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                // Founder Quote and Book Consultation Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"Success is not just about what you achieve, but about the impact you make on the world. Embrace challenges, learn continuously, and stay determined."',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '– [Founder Name]',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Action for booking consultation
                        },
                        child: Text('Book Consultation'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
