import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'founder_card.dart';
import '../../../constants.dart';

class TabletAbout extends StatelessWidget {
  final List<Founder> founders;

  const TabletAbout({Key? key, required this.founders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 120,
                bottom: 60,
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: const [
                        TextSpan(text: 'Meet Our '),
                        TextSpan(
                          text: 'Mentors',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => FounderCard(
                    founder: founders[index],
                    isTablet: true,
                  ),
                  childCount: founders.length,
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 60),
            ),
          ],
        ),
      ),
    );
  }
}