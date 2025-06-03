import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  static const Color primaryColor = Color(0xFF1A237E); // Biru tua
  static const Color accentColor = Color(0xFFFF9800); // Oranye
  static const Color bgColor = Color(0xFF212121); // Abu-abu gelap

  @override
  Widget build(BuildContext context) {
    // Contoh data pesanan (ganti dengan data dari API)
    final List<Map<String, String>> orders = [
      {
        "orderId": "ORD001",
        "customer": "Budi",
        "product": "Pagar Minimalis",
        "status": "Menunggu",
      },
      {
        "orderId": "ORD002",
        "customer": "Siti",
        "product": "Kanopi Modern",
        "status": "Diproses",
      },
      {
        "orderId": "ORD003",
        "customer": "Andi",
        "product": "Teralis Jendela",
        "status": "Selesai",
      },
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Kelola Pesanan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: accentColor),
              title: Text(
                'Pesanan ${order['orderId']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pelanggan: ${order['customer']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Produk: ${order['product']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Status: ${order['status']}',
                    style: TextStyle(
                      color: order['status'] == 'Selesai'
                          ? Colors.greenAccent
                          : (order['status'] == 'Diproses'
                                ? accentColor
                                : Colors.redAccent),
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'detail') {
                    // TODO: Lihat detail pesanan
                  } else if (value == 'update') {
                    // TODO: Update status pesanan
                  } else if (value == 'delete') {
                    // TODO: Hapus pesanan
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'detail', child: Text('Detail')),
                  const PopupMenuItem(
                    value: 'update',
                    child: Text('Update Status'),
                  ),
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
