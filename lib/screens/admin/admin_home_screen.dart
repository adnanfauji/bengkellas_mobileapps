import 'package:flutter/material.dart';
import 'manage_orders_screen.dart';
import 'manage_services_screen.dart';
import 'manage_products_screen.dart';
import 'manage_users_screen.dart';
import 'settings_screen.dart';
import '../auth/login_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  final dynamic userId; // Tambahkan parameter userId

  const AdminHomeScreen({super.key, required this.userId});

  static const Color primaryColor = Color(0xFF1A237E); // Biru tua
  static const Color accentColor = Color(0xFFFF9800); // Oranye
  static const Color bgColor = Color(0xFF212121); // Abu-abu gelap

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Admin Bengkel Las',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout'),
                      onPressed: () {
                        // TODO: Hapus session/token jika ada
                        Navigator.of(context).pop(); // Tutup dialog konfirmasi
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: [
            _buildAdminMenu(
              context,
              icon: Icons.list_alt,
              label: 'Kelola Pesanan',
              color: accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageOrdersScreen()),
                );
              },
            ),
            _buildAdminMenu(
              context,
              icon: Icons.build,
              label: 'Kelola Layanan',
              color: accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageServicesScreen(),
                  ),
                );
              },
            ),
            _buildAdminMenu(
              context,
              icon: Icons.shopping_bag,
              label: 'Kelola Produk',
              color: accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageProductsScreen(),
                  ),
                );
              },
            ),
            _buildAdminMenu(
              context,
              icon: Icons.people,
              label: 'Kelola User',
              color: accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMenu(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
