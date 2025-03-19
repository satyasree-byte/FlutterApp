import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/tabs_layout.dart';

class AboutTab extends StatelessWidget {
  final List<Founder> founders = [
    Founder(
      name: "Akash Dwivedi",
      role: "Founder & CEO",
      imageUrl: "assets/images/Founder.jpeg",
      linkedinUrl: "https://www.linkedin.com/in/akash-kumar-silicon",
      bio: "AI Engineer with 11+ years of experience in software engineering, AI, and quality assurance.",
    ),
    Founder(
      name: "John Doe",
      role: "Co-founder & CTO",
      imageUrl: "assets/images/Founder2.jpeg",
      linkedinUrl: "https://www.linkedin.com/in/satyasree-annapragada/",
      bio: "Tech enthusiast with expertise in cloud computing, cybersecurity, and scalable architectures.",
    ),
    // Add more founders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Make the entire screen scrollable
      child: Container(
        key: ValueKey<int>(3),
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
        child: Padding(
          padding: const EdgeInsets.only(top:10.0).add(EdgeInsets.all(50.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55.0),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(text: 'Meet Our ', style: TextStyle(color: Colors.white)),
                      TextSpan(
                        text: 'Founders',
                        style: TextStyle(color: Colors.blueAccent), // Different color for "Founders"
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // Adjust space if necessary
              
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Adjust padding as needed
                child: GridView.builder(
                  shrinkWrap: true, // Prevents GridView from expanding and causing overflow
                  physics: NeverScrollableScrollPhysics(), // Disables scrolling in GridView
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1, // 3 items per row on large screens, 1 per row on small screens
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: founders.length,
                  itemBuilder: (context, index) {
                    return FounderCard(founder: founders[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Founder {
  final String name;
  final String role;
  final String imageUrl;
  final String linkedinUrl;
  final String bio;

  Founder({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.linkedinUrl,
    required this.bio,
  });
}

class FounderCard extends StatefulWidget {
  final Founder founder;

  const FounderCard({Key? key, required this.founder}) : super(key: key);

  @override
  _FounderCardState createState() => _FounderCardState();
}

class _FounderCardState extends State<FounderCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isHovered
                ? [Colors.deepPurpleAccent, Colors.blueAccent]
                : [Colors.black54, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: isHovered
              ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.6), blurRadius: 15)]
              : [BoxShadow(color: Colors.black45, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Hero(
              tag: widget.founder.imageUrl,
              child: CircleAvatar(
                radius: isHovered ? 80 : 70, // Increase size more on hover (default 60)
                backgroundImage: AssetImage(widget.founder.imageUrl),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.founder.name,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              widget.founder.role,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[300]),
            ),
            SizedBox(height: 10),
            Text(
              widget.founder.bio,
              style: TextStyle(fontSize: 12, color: Colors.grey[400], fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
             IconButton(
              icon: FaIcon(
                FontAwesomeIcons.linkedin, // Use FontAwesome LinkedIn icon
                color: Colors.blueAccent,
              ),
              onPressed: () => _launchURL(widget.founder.linkedinUrl),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
