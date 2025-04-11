import 'package:flutter/material.dart';
import 'ui/main_page.dart';
import 'theme/app_theme.dart';
import 'ui/tabs/career_guidance_tab.dart'; // Your Career Guidance Page
import 'data/tabs_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await Future.delayed(const Duration(milliseconds: 500)); // Delay to allow initialization
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Initialize analytics
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EDUVISE.AI',
      theme: AppTheme.themeData,
      home: const MainPage(),

      // Essential for screen tracking
      navigatorObservers: [observer],

      // Optional: Set default analytics parameters
      builder: (context, child) {
        // Set user properties
        analytics.setUserProperty(
          name: 'platform',
          value: 'web',  // Hardcoded since this is web-only
        );
        return child!;
      },
    );
  }
}
