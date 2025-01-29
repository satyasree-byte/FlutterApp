import 'package:flutter/material.dart';
import 'colors.dart';  // Ensure you import the correct file path

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: customWhite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Logo Section
          Row(
            children: [
              Icon(
                Icons.school,
                size: 40,
                color: vibrantBrightPurple,
              ),
              const SizedBox(width: 8),
              const Text(
                'AcademiX',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: vibrantBrightPurple,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Navigation Links with Hover Animation
          Row(
            children: [
              _navLink('Home'),
              const SizedBox(width: 20),
              _navLink('Knowledge Center'),
              const SizedBox(width: 20),
              _navLink('Career Guidance'),
              const SizedBox(width: 20),
              _navLink('About Us'),
              const SizedBox(width: 20),
              _navLink('Contact'),
              const SizedBox(width: 20),
            ],
          ),
          const Spacer(),
          // Search Bar with Animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for courses...',
                prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blueGrey),
                ),
                filled: true,
                fillColor: customWhite,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Login / Sign Up Button with Gesture Detection
          GestureDetector(
            onTap: () {
              // Action for Login/Sign Up
              print('Login / Sign Up clicked');
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: vibrantBrightPurple,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: const Text(
                'Login / Sign Up',
                style: TextStyle(
                  color: customWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Link with Hover Animation
  Widget _navLink(String label) {
    return GestureDetector(
      onTap: () {
        print('$label clicked');
        // Navigation logic goes here (e.g., Navigator.push)
      },
      child: MouseRegion(
        onEnter: (_) {
          // Change color on hover
        },
        onExit: (_) {
          // Revert color when hover ends
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: customBlack,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
