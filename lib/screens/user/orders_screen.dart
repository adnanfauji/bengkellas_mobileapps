import 'package:flutter/material.dart';
import '../../config/config.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Pesanan'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pesanan Aktif'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildActiveOrders(), _buildOrderHistory()],
        ),
      ),
    );
  }

  Widget _buildActiveOrders() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: activeOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(activeOrders[index], true);
      },
    );
  }

  Widget _buildOrderHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orderHistory.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orderHistory[index], false);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, bool isActive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['id']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Chip(
                  label: Text(
                    order['status'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(order['status']),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(order['item'], style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 4.0),
            Text(
              order['price'],
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Tanggal: ${order['date']}'),
            if (isActive) ...[
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement track order
                      },
                      child: const Text('Lacak Pesanan'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement contact admin
                      },
                      child: const Text('Hubungi Admin'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Dalam Proses':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  static final List<Map<String, dynamic>> activeOrders = [
    {
      'id': '001',
      'item': 'Pagar Minimalis 3 Meter',
      'price': 'Rp 1.500.000',
      'date': '2024-01-15',
      'status': 'Dalam Proses',
    },
    {
      'id': '002',
      'item': 'Kanopi Modern 2 Meter',
      'price': 'Rp 700.000',
      'date': '2024-01-14',
      'status': 'Menunggu Konfirmasi',
    },
  ];

  static final List<Map<String, dynamic>> orderHistory = [
    {
      'id': '003',
      'item': 'Teralis Jendela 1.5 Meter',
      'price': 'Rp 450.000',
      'date': '2024-01-10',
      'status': 'Selesai',
    },
    {
      'id': '004',
      'item': 'Pintu Besi Custom',
      'price': 'Rp 2.000.000',
      'date': '2024-01-05',
      'status': 'Selesai',
    },
    {
      'id': '005',
      'item': 'Railing Tangga 2 Meter',
      'price': 'Rp 900.000',
      'date': '2024-01-01',
      'status': 'Dibatalkan',
    },
  ];

  final url = '${AppConfig.baseUrl}get_products.php';
}
