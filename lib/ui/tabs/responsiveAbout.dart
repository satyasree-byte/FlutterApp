// lib/ui/tabs/responsiveAbout.dart
import 'package:flutter/material.dart';
import 'about/mobile_about.dart';
import 'about/tablet_about.dart';
import 'about/desktop_about.dart';
import '../../constants.dart';
import 'about/founder_card.dart';

class ResponsiveAbout extends StatelessWidget {
  final List<Founder> founders;

  const ResponsiveAbout({
    Key? key,
    required this.founders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ScreenSize.desktop) {
          return DesktopAbout(founders: founders);
        } else if (constraints.maxWidth >= ScreenSize.tablet) {
          return TabletAbout(founders: founders);
        } else {
          return MobileAbout(founders: founders);
        }
      },
    );
  }
}