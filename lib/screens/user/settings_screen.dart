import 'package:bengkellas_mobileapps/screens/user/profil_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color primaryColor = Color(0xFF1A237E);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color bgColor = Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: accentColor),
            title: const Text(
              'Profil Saya',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: accentColor),
            title: const Text(
              'Ganti Password',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // TODO: Navigasi ke halaman ganti password user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur belum tersedia')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: accentColor),
            title: const Text(
              'Tentang Aplikasi',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Bengkel Las Mobile Apps',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Bengkel Las',
              );
            },
          ),
        ],
      ),
    );
  }
}
