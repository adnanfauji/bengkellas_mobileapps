import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../config/config.dart';
import 'custom_order_screen.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'contact_screen.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';

class HomePage extends StatefulWidget {
  final dynamic userId;

  const HomePage({super.key, required this.userId});

  static const Color primaryColor = Color(0xFF1A237E);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color bgColor = Color(0xFF212121);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
    fetchServices();
    fetchProducts();
  }

  Future<Map<String, dynamic>> fetchUser() async {
    try {
      final url = Uri.parse(
        '${AppConfig.baseUrl}get_user_profile.php?id=${widget.userId}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['user'];
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }

    // Default jika gagal
    return {'nama': 'User', 'email': 'user@example.com'};
  }

  Future<List<dynamic>> fetchServices() async {
    final url = Uri.parse('${AppConfig.baseUrl}get_services.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return data['services'];
      }
    }
    return [];
  }

  Future<List<dynamic>> fetchProducts() async {
    final url = Uri.parse('${AppConfig.baseUrl}get_products.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return data['products'];
      }
    }
    return [];
  }

  String formatRupiah(dynamic nominal) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    int value = 0;
    if (nominal is int) {
      value = nominal;
    } else if (nominal is String) {
      value = int.tryParse(nominal) ?? 0;
    }
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bengkel Las')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _userFuture,
              builder: (context, snapshot) {
                final nama = snapshot.data?['nama_lengkap'] ?? 'User';
                final email = snapshot.data?['email'] ?? 'user@example.com';
                return UserAccountsDrawerHeader(
                  accountName: Text(nama),
                  accountEmail: Text(email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  decoration: const BoxDecoration(color: Colors.blue),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_repair_service),
              title: const Text('Layanan'),
              onTap: () {
                // Navigate to services page
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Produk'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Pesanan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_phone),
              title: const Text('Kontak'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(context, 'Layanan Las', Icons.home_repair_service, () {
            // Navigate to welding services
          }),
          _buildMenuCard(context, 'Produk', Icons.shopping_cart, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductsScreen()),
            );
          }),
          _buildMenuCard(context, 'Pesan Custom', Icons.add_box, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomOrderScreen(),
              ),
            );
          }),
          _buildMenuCard(context, 'Kontak', Icons.contact_phone, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      color: HomePage.primaryColor,
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: HomePage.accentColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
