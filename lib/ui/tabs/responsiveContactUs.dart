// lib/ui/tabs/responsiveContact.dart
import 'package:flutter/material.dart';
import 'contactUs/mobile_contactUs.dart';
import 'contactUs/tablet_contactUs.dart';
import 'contactUs/desktop_contactUs.dart';
import 'contactUs/contact_info_card.dart';
import '../../constants.dart';

class ResponsiveContact extends StatelessWidget {
  const ResponsiveContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ScreenSize.desktop) {
          return const DesktopContact();
        } else if (constraints.maxWidth >= ScreenSize.tablet) {
          return const TabletContact();
        } else {
          return const MobileContact();
        }
      },
    );
  }
}