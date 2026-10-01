import 'package:flutter/material.dart';
import 'package:insta_downloader/screen/downloads_screen.dart';
import 'package:insta_downloader/screen/history_screen.dart';
import 'package:insta_downloader/screen/home_screen.dart';
import 'package:insta_downloader/screen/settings_screen.dart';
import 'package:insta_downloader/screen/side_menu_screen.dart';
import 'package:insta_downloader/widget/bottom_nav_bar.dart';
import '../../../core/utils/strings_service.dart';

/// Shell with bottom nav: Home | Downloads | History | Settings
class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final home = StringsService.strings.home;
    final labels = [
      home.nav['home']!,
      home.nav['downloads']!,
      home.nav['history']!,
      home.nav['settings']!,
    ];

    final pages = [
      HomeScreen(
          onOpenMenu: openDrawer,
          onNavChanged: (i) => setState(() => _index = i)),
      const DownloadsScreen(),
      const HistoryScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: SideMenuDrawer(
        currentIndex: _index,
        onSelect: (i) => setState(() => _index = i),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: pages[_index]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              currentIndex: _index,
              isDark: isDark,
              labels: labels,
              onTap: (i) => setState(() => _index = i),
            ),
          ),
        ],
      ),
    );
  }
}
