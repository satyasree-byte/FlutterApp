// responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 500) {
      return baseSize * 0.7; // Smaller font for mobile
    } else if (screenWidth < 800) {
      return baseSize * 0.8; // Normal font for tablet
    } else {
      return baseSize * 1.0; // Larger font for desktop
    }
  }

  static double getResponsiveImageSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 500) {
      return baseSize * 0.6; // Smaller image for mobile
    } else if (screenWidth < 800) {
      return baseSize * 0.8; // Medium image for tablet
    } else {
      return baseSize * 1.0; // Full size for desktop
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 500) {
      return EdgeInsets.symmetric(horizontal: 8, vertical: 8); // Compact padding for mobile
    } else if (screenWidth < 800) {
      return EdgeInsets.symmetric(horizontal: 16, vertical: 16); // Medium padding for tablet
    } else {
      return EdgeInsets.symmetric(horizontal: 32, vertical: 32); // Spacious padding for desktop
    }
  }
}