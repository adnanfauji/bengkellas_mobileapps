import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/config.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  static const Color primaryColor = Color(0xFF1A237E); // Biru tua
  static const Color accentColor = Color(0xFFFF9800); // Oranye
  static const Color bgColor = Color(0xFF212121); // Abu-abu gelap

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final url = Uri.parse('${AppConfig.baseUrl}get_users.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return List<Map<String, dynamic>>.from(data['users']);
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil data user');
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _usersFuture = fetchUsers();
    });
  }

  Future<void> _deleteUser(String id) async {
    final url = Uri.parse('${AppConfig.baseUrl}delete_user.php');
    final response = await http.post(url, body: {'id': id});
    final data = jsonDecode(response.body);
    if (data['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User berhasil dihapus')));
      _refreshUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Gagal menghapus user')),
      );
    }
  }

  Future<void> _editUser(Map<String, dynamic> user) async {
    final nameController = TextEditingController(text: user['nama_lengkap']);
    final usernameController = TextEditingController(text: user['username']);
    final emailController = TextEditingController(text: user['email']);
    final phoneController = TextEditingController(text: user['no_hp']);
    String selectedRole = user['role'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'No HP'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('User')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  if (value != null) selectedRole = value;
                },
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
              final url = Uri.parse('${AppConfig.baseUrl}edit_user.php');
              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'id': user['id'].toString(),
                  'username': usernameController.text,
                  'nama_lengkap': nameController.text,
                  'email': emailController.text,
                  'no_hp': phoneController.text,
                  'role': selectedRole,
                }),
              );
              final data = jsonDecode(response.body);
              Navigator.pop(context);
              if (data['success']) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User berhasil diupdate')),
                );
                _refreshUsers();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(data['message'] ?? 'Gagal update user'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User'),
        content: Text(
          'Yakin ingin menghapus user "${user['nama_lengkap'] ?? user['username']}"?',
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Hapus'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user['id'].toString());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManageUsersScreen.bgColor,
      appBar: AppBar(
        backgroundColor: ManageUsersScreen.primaryColor,
        title: const Text('Kelola User', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: ManageUsersScreen.accentColor,
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
                'Tidak ada user',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          final users = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshUsers,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  color: ManageUsersScreen.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      user['role'] == 'admin'
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      color: ManageUsersScreen.accentColor,
                    ),
                    title: Text(
                      user['nama_lengkap'] ?? user['username'] ?? '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['email'] ?? '-',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Role: ${user['role']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editUser(user);
                        } else if (value == 'delete') {
                          _confirmDelete(user);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
