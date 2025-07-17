import 'package:flutter/material.dart';

import '../../widgets/now_playing_banner.dart';
import 'tabs/home_tab.dart';
import 'tabs/map_tab.dart';
import 'tabs/qr_tab.dart';
import 'tabs/settings_tab.dart';
import 'tabs/story_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const StoryTab(),
    const QrTab(),
    const MapTab(),
    const SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Hiển thị icon từ asset, căn giữa, không có label
  Widget buildCenteredNavIcon(String assetPath, {double size = 28}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Nội dung chính
        Scaffold(
          extendBody: true,
          body: _tabs[_selectedIndex],
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 28,
              top: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  selectedItemColor: Colors.blueAccent,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  backgroundColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: buildCenteredNavIcon('assets/icons/home.png'),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: buildCenteredNavIcon('assets/icons/story.png'),
                      label: 'Story',
                    ),
                    BottomNavigationBarItem(
                      icon: buildCenteredNavIcon('assets/icons/qr.png'),
                      label: 'QR',
                    ),
                    BottomNavigationBarItem(
                      icon: buildCenteredNavIcon('assets/icons/map.png'),
                      label: 'Map',
                    ),
                    BottomNavigationBarItem(
                      icon: buildCenteredNavIcon('assets/icons/setting.png'),
                      label: 'Setting',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          left: 1,
          right: 1,
          bottom: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              NowPlayingBanner(),
              SizedBox(height: 8), // để cách mép một chút
            ],
          ),
        ),
      ],
    );
  }
}
