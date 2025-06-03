import 'package:flutter/material.dart';

class ManageServicesScreen extends StatelessWidget {
  const ManageServicesScreen({super.key});

  static const Color primaryColor = Color(0xFF1A237E); // Biru tua
  static const Color accentColor = Color(0xFFFF9800); // Oranye
  static const Color bgColor = Color(0xFF212121); // Abu-abu gelap

  @override
  Widget build(BuildContext context) {
    // Contoh data layanan (ganti dengan data dari API)
    final List<Map<String, String>> services = [
      {"name": "Pagar Minimalis", "desc": "Desain modern dan kuat"},
      {"name": "Kanopi Modern", "desc": "Pelindung rumah dari hujan & panas"},
      {"name": "Teralis Jendela", "desc": "Keamanan ekstra untuk rumah"},
      {"name": "Pintu Besi", "desc": "Pintu besi custom sesuai kebutuhan"},
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Kelola Layanan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // TODO: Tambah layanan baru
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.build, color: accentColor),
              title: Text(
                service['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                service['desc']!,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    // TODO: Edit layanan
                  } else if (value == 'delete') {
                    // TODO: Hapus layanan
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
