import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (i) {
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: _buildNavItem(i),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(int i) {
    final icons = [
      Icons.home,
      Icons.calendar_today,
      Icons.access_time,
      Icons.video_library,
      Icons.settings,
    ];

    final labels = ["Beranda", "Jadwal", "Riwayat", "Favorit", "Setting"];

    final bool isActive = (i == currentIndex);

    if (isActive) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -8,
                child: Container(
                  width: 60,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(icons[i], color: Colors.black, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            labels[i],
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icons[i], size: 26, color: Colors.white70)],
      );
    }
  }
}
