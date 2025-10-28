import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'ui/main_page.dart';
import 'theme/app_theme.dart';
import 'ui/tabs/career_guidance_tab.dart'; // Your Career Guidance Page
import 'data/tabs_layout.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 500)); // Delay to allow initialization
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EDUVISE.AI',
      theme: AppTheme.themeData,
      home: const MainPage(),
    );
  }
}
