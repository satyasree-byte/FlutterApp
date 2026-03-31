// responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.80; // Small phones (SE, older)
    } else if (screenWidth < 500) {
      return baseSize * 0.88; // Standard mobile
    } else if (screenWidth < 800) {
      return baseSize * 0.92; // Tablet
    } else {
      return baseSize * 1.0; // Desktop
    }
  }

  static double getResponsiveImageSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.70;
    } else if (screenWidth < 500) {
      return baseSize * 0.80;
    } else if (screenWidth < 800) {
      return baseSize * 0.88;
    } else {
      return baseSize * 1.0;
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 500) {
      return EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    } else if (screenWidth < 800) {
      return EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    } else {
      return EdgeInsets.symmetric(horizontal: 32, vertical: 32);
    }
  }
}