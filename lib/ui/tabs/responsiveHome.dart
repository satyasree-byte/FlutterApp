import 'package:flutter/material.dart';
import 'services/bookServiceForm.dart';
import '../utils/responsive_helper.dart';
import 'home/mobile_home.dart';
import 'home/tablet_home.dart';
import 'home/desktop_home.dart';

class responsive_Home extends StatefulWidget {
  const responsive_Home({Key? key}) : super(key: key);

  @override
  _ResponsiveHomeTabState createState() => _ResponsiveHomeTabState();
}

class _ResponsiveHomeTabState extends State<responsive_Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _serviceKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    Scrollable.ensureVisible(
      _serviceKeys[index].currentContext!,
      duration: Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine the layout based on screen size
    Widget body;
    if (screenWidth < 500) {
      // Mobile layout
      body = MobileHome(
        tabController: _tabController,
        scrollToIndex: _scrollToIndex,
        serviceKeys: _serviceKeys,
      );
    } else if (screenWidth < 800) {
      // Tablet layout
      body = TabletHome(
        tabController: _tabController,
        scrollToIndex: _scrollToIndex,
        serviceKeys: _serviceKeys,
      );
    } else {
      // Desktop layout
      body = DesktopHome(
        tabController: _tabController,
        scrollToIndex: _scrollToIndex,
        serviceKeys: _serviceKeys,
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/tech.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: body, // Use the responsive body
      ),
    );
  }
}