import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _settingsItem(
            context,
            title: 'Account',
            subtitle: 'Manage your account settings',
          ),
          const Divider(),
          _settingsItem(
            context,
            title: 'Notifications',
            subtitle: 'Customize your notifications',
          ),
          const Divider(),
          _settingsItem(
            context,
            title: 'Privacy',
            subtitle: 'Adjust your privacy preferences',
          ),
          const Divider(),
          _settingsItem(
            context,
            title: 'About',
            subtitle: 'Learn more about the app',
          ),
        ],
      ),
      //bottomNavigationBar: bottomBar(context),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Settings',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey[200],
      elevation: 0.0,
      centerTitle: true,
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
              Navigator.pushNamed(context, '/home');
            },
            icon: const Icon(Icons.home),
            tooltip: 'Home',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _settingsItem(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Placeholder for navigation or action
        debugPrint('$title tapped');
      },
    );
  }
}
