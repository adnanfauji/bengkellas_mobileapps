import 'package:flutter/material.dart';
import '../config/config.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({super.key});

  @override
  State<CustomOrderScreen> createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _dimensionsController = TextEditingController();
  String? _selectedCategory;
  List<String> _attachments = [];

  final List<String> _categories = [
    'Pagar',
    'Kanopi',
    'Teralis',
    'Pintu',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Custom'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori Produk',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih kategori produk';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dimensionsController,
                decoration: const InputDecoration(
                  labelText: 'Ukuran (Panjang x Lebar x Tinggi)',
                  border: OutlineInputBorder(),
                  hintText: 'Contoh: 200cm x 100cm x 150cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan ukuran';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Pesanan',
                  border: OutlineInputBorder(),
                  hintText: 'Jelaskan detail pesanan Anda...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan deskripsi pesanan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement image picker
                  setState(() {
                    _attachments.add('Gambar_${_attachments.length + 1}.jpg');
                  });
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Tambah Referensi Gambar'),
              ),
              if (_attachments.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _attachments.map((attachment) {
                    return Chip(
                      label: Text(attachment),
                      onDeleted: () {
                        setState(() {
                          _attachments.remove(attachment);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement order submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pesanan berhasil dikirim!'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Kirim Pesanan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _dimensionsController.dispose();
    super.dispose();
  }
}

final url = '${AppConfig.baseUrl}get_products.php';
