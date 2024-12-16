import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Navigation',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Fullscreen Image
          Expanded(
            child: Image.asset(
              'assets/icons/NavigationScreen.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                enabled: false, // Non-functional
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar(context), // Add the bottom bar
    );
  }

  Widget bottomBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              // Navigate to the Map page
              Navigator.pushNamed(context, '/map');
            },
            icon: SvgPicture.asset('assets/icons/motorbike.svg', height: 34, width: 34),
            tooltip: 'Home',
          ),
          _circleButton(
            context,
            'assets/icons/helmet.svg',
            'Settings',
            Colors.green,
            () => Navigator.pushNamed(context, '/home'),
          ),
          IconButton(
            onPressed: () {
              // Navigate to the Profile page
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _circleButton(
      BuildContext context, String iconPath, String tooltip, Color color, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(iconPath),
        ),
      ),
      tooltip: tooltip,
    );
  }
}
