import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../config/config.dart';

Future<List<dynamic>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('${AppConfig.baseUrl}get_products.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load products');
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Las'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final productsList = snapshot.data!;
            return ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(productsList[index]['nama_produk']),
                  subtitle: Text('Rp ${productsList[index]['harga']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
