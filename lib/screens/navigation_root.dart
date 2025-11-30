import 'package:flutter/material.dart';
import 'package:weebsoul/screens/home_page.dart';
import 'package:weebsoul/screens/jadwal_page.dart';
import 'package:weebsoul/screens/riwayat_page.dart';
import 'package:weebsoul/widgets/custom_navbar.dart';
import 'package:weebsoul/screens/setting_page.dart';
import 'package:weebsoul/screens/subscribed_anime_page.dart';

class NavigationRoot extends StatefulWidget {
  const NavigationRoot({super.key});

  @override
  State<NavigationRoot> createState() => _NavigationRootState();
}

class _NavigationRootState extends State<NavigationRoot> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SchedulePage(),
    RiwayatPage(),
    SubscribedAnimePage(), // Favorit
    SettingPage(), // Setting
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: pages[currentIndex], // <-- HALAMAN BERGANTI
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: (i) {
          setState(() {
            currentIndex = i; // <-- INDEX DIGANTI
          });
        },
      ),
    );
  }
}
