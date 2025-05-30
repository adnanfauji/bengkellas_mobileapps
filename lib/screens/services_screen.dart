import 'package:flutter/material.dart';
import '../config/config.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Las'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildServiceCategory('Layanan Las Pagar', [
            ServiceItem(
              'Pagar Minimalis',
              'Desain modern dengan bahan berkualitas',
              'Mulai dari Rp 500.000/meter',
              ['Besi Hollow 4x4', 'Finishing Cat', 'Pemasangan'],
            ),
            ServiceItem(
              'Pagar Klasik',
              'Desain mewah dengan ornamen klasik',
              'Mulai dari Rp 750.000/meter',
              ['Besi Tempa', 'Finishing Cat', 'Pemasangan'],
            ),
          ]),
          _buildServiceCategory('Layanan Las Kanopi', [
            ServiceItem(
              'Kanopi Minimalis',
              'Desain simpel dan modern',
              'Mulai dari Rp 350.000/meter',
              ['Besi Hollow', 'Atap Spandek', 'Pemasangan'],
            ),
            ServiceItem(
              'Kanopi Premium',
              'Desain eksklusif dengan material premium',
              'Mulai dari Rp 500.000/meter',
              ['Besi Galvanis', 'Atap Alderon', 'Pemasangan'],
            ),
          ]),
          _buildServiceCategory('Layanan Las Teralis', [
            ServiceItem(
              'Teralis Jendela Standard',
              'Desain fungsional dan aman',
              'Mulai dari Rp 300.000/meter',
              ['Besi Hollow', 'Finishing Cat', 'Pemasangan'],
            ),
            ServiceItem(
              'Teralis Jendela Minimalis',
              'Desain modern dengan keamanan optimal',
              'Mulai dari Rp 400.000/meter',
              ['Besi Hollow Premium', 'Finishing Cat', 'Pemasangan'],
            ),
          ]),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement custom order
        },
        label: const Text('Pesan Custom'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildServiceCategory(String title, List<ServiceItem> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...services.map((service) => _buildServiceCard(service)).toList(),
      ],
    );
  }

  Widget _buildServiceCard(ServiceItem service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        title: Text(
          service.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(service.price),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.description,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Termasuk:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...service.includes.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 20.0),
                        const SizedBox(width: 8.0),
                        Text(item),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement order process
                  },
                  child: const Text('Pesan Sekarang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  final String name;
  final String description;
  final String price;
  final List<String> includes;

  ServiceItem(this.name, this.description, this.price, this.includes);
}

final url = '${AppConfig.baseUrl}get_products.php';
