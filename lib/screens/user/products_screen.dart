import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../config/config.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static const Color primaryColor = Color(0xFF1A237E); // Biru tua
  static const Color accentColor = Color(0xFFFF9800); // Oranye
  static const Color bgColor = Color(0xFF212121); // Abu-abu gelap

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Map<String, dynamic>>> _productsFuture;
  final String baseImageUrl = "${AppConfig.baseUrl}uploads/";

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}get_products.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Validasi struktur respons JSON
        if (data['success'] && data['products'] is List) {
          return List<Map<String, dynamic>>.from(data['products']);
        } else {
          throw Exception(data['message'] ?? 'Gagal mengambil data produk');
        }
      } else {
        throw Exception('Gagal terhubung ke server: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetch products: $e');
      throw Exception('Terjadi kesalahan saat mengambil data produk');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProductsScreen.bgColor,
      appBar: AppBar(
        backgroundColor: ProductsScreen.primaryColor,
        title: const Text('Produk Las', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: ProductsScreen.accentColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada produk',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final products = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final currencyFormatter = NumberFormat('#,##0', 'id_ID');
    final hargaFormatted = currencyFormatter.format(
      int.tryParse(product['harga'].toString()) ?? 0,
    );

    return Card(
      color: ProductsScreen.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading:
            (product['gambar'] != null &&
                product['gambar'].toString().isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product['gambar'].toString().startsWith('http')
                      ? product['gambar']
                      : baseImageUrl + product['gambar'],
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    color: ProductsScreen.accentColor,
                    size: 48,
                  ),
                ),
              )
            : Icon(
                Icons.shopping_bag,
                color: ProductsScreen.accentColor,
                size: 48,
              ),
        title: Text(
          product['nama_produk'] ?? '-',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['deskripsi'] ?? '-',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'Harga: Rp $hargaFormatted',
              style: const TextStyle(color: Colors.orangeAccent),
            ),
            Text(
              'Stok: ${product['stok']}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
