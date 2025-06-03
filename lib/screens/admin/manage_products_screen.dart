import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Tambahkan ini
import '../../config/config.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  static const Color primaryColor = Color(0xFF1A237E); // Biru tua
  static const Color accentColor = Color(0xFFFF9800); // Oranye
  static const Color bgColor = Color(0xFF212121); // Abu-abu gelap

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  late Future<List<Map<String, dynamic>>> _productsFuture;
  File? _pickedImage;
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

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = fetchProducts();
    });
  }

  Future<void> _deleteProduct(String id) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}delete_product.php');
      final response = await http.post(url, body: {'id': id});
      final data = jsonDecode(response.body);

      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus')),
        );
        _refreshProducts();
      } else {
        throw Exception(data['message'] ?? 'Gagal menghapus produk');
      }
    } catch (e) {
      print('Error delete product: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  Future<void> _editProduct(Map<String, dynamic> product) async {
    final nameController = TextEditingController(text: product['nama_produk']);
    final descController = TextEditingController(text: product['deskripsi']);
    final priceController = TextEditingController(
      text: product['harga'].toString(),
    );
    final stockController = TextEditingController(
      text: product['stok'].toString(),
    );
    final imageController = TextEditingController(
      text: product['gambar'] ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Produk'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () async {
              try {
                final url = Uri.parse('${AppConfig.baseUrl}edit_product.php');
                final response = await http.post(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'id': product['id'].toString(),
                    'nama_produk': nameController.text,
                    'deskripsi': descController.text,
                    'harga': priceController.text,
                    'stok': stockController.text,
                    'gambar': imageController.text,
                  }),
                );
                final data = jsonDecode(response.body);
                Navigator.pop(context);

                if (data['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produk berhasil diupdate')),
                  );
                  _refreshProducts();
                } else {
                  throw Exception(data['message'] ?? 'Gagal update produk');
                }
              } catch (e) {
                print('Error edit product: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Terjadi kesalahan: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text(
          'Yakin ingin menghapus produk "${product['nama_produk']}"?',
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(product['id'].toString());
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _addProduct() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    _pickedImage = null; // reset gambar

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Tambah Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 75,
                    );
                    if (pickedFile != null) {
                      setStateDialog(() {
                        _pickedImage = File(pickedFile.path);
                      });
                    }
                  },
                  child: _pickedImage != null
                      ? Image.file(
                          _pickedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.camera_alt, size: 40),
                        ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () async {
                try {
                  final url = Uri.parse('${AppConfig.baseUrl}add_product.php');
                  var request = http.MultipartRequest('POST', url);
                  request.fields['nama_produk'] = nameController.text;
                  request.fields['deskripsi'] = descController.text;
                  request.fields['harga'] = priceController.text;
                  request.fields['stok'] = stockController.text;

                  if (_pickedImage != null) {
                    request.files.add(
                      await http.MultipartFile.fromPath(
                        'gambar',
                        _pickedImage!.path,
                      ),
                    );
                  }

                  final response = await request.send();
                  final respStr = await response.stream.bytesToString();
                  final data = jsonDecode(respStr);
                  Navigator.pop(context);

                  if (data['success']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk berhasil ditambahkan'),
                      ),
                    );
                    _refreshProducts();
                  } else {
                    throw Exception(data['message'] ?? 'Gagal tambah produk');
                  }
                } catch (e) {
                  print('Error add product: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terjadi kesalahan: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManageProductsScreen.bgColor,
      appBar: AppBar(
        backgroundColor: ManageProductsScreen.primaryColor,
        title: const Text(
          'Kelola Produk',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addProduct,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: ManageProductsScreen.accentColor,
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
          return RefreshIndicator(
            onRefresh: _refreshProducts,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(product);
              },
            ),
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
      color: ManageProductsScreen.primaryColor,
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
                    color: ManageProductsScreen.accentColor,
                    size: 48,
                  ),
                ),
              )
            : Icon(
                Icons.shopping_bag,
                color: ManageProductsScreen.accentColor,
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
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 'edit') {
              _editProduct(product);
            } else if (value == 'delete') {
              _confirmDelete(product);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Hapus')),
          ],
        ),
      ),
    );
  }
}
