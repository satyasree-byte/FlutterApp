import 'package:flutter/material.dart';
import 'about/mobile_why_choose_us.dart';
import 'about/tablet_why_choose_us.dart';
import 'about/desktop_why_choose_us.dart';
import '../../constants.dart';

class ResponsiveAbout extends StatelessWidget {
  const ResponsiveAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ScreenSize.desktop) {
          return const DesktopWhyChooseUs();
        } else if (constraints.maxWidth >= ScreenSize.tablet) {
          return const TabletWhyChooseUs();
        } else {
          return const MobileWhyChooseUs();
        }
      },
    );
  }
}
