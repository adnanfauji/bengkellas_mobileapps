import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/config.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF1A237E);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color bgColor = Color(0xFF212121);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userFuture;
  Map<String, dynamic> userData = {};
  final _formKey = GlobalKey<FormState>();
  bool _showError = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController hpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
  }

  Future<int?> getUserId() async {
    // Panggil API untuk mendapatkan userId
    final url = Uri.parse(
      '${AppConfig.baseUrl}get_user_id.php',
    ); // Sesuaikan endpoint API
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return data['userId']; // Pastikan API mengembalikan userId
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('Error: ${response.statusCode}');
    }

    // Default jika gagal
    return null;
  }

  Future<Map<String, dynamic>> fetchUser() async {
    // Panggil API untuk mendapatkan data pengguna
    final url = Uri.parse('${AppConfig.baseUrl}get_user_profile.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        userData = data['user'];
        usernameController.text = userData['username'] ?? '';
        namaController.text = userData['nama_lengkap'] ?? '';
        emailController.text = userData['email'] ?? '';
        hpController.text = userData['no_hp'] ?? '';
        alamatController.text = userData['alamat'] ?? '';
        profilePictureUrl = userData['profile_picture'];
        return userData;
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('Error: ${response.statusCode}');
    }

    // Default jika gagal
    return {};
  }

  Future<void> updateUser() async {
    final url = Uri.parse('${AppConfig.baseUrl}update_user.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userData['id'].toString(),
        'username': usernameController.text,
        'nama_lengkap': namaController.text,
        'email': emailController.text,
        'no_hp': hpController.text,
        'alamat': alamatController.text,
        'profile_picture': profilePictureUrl ?? '',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        setState(() {
          _userFuture = fetchUser();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal update')),
        );
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await uploadProfilePicture(imageFile);
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      // Panggil API untuk mengunggah gambar dan data pengguna
      final url = Uri.parse('${AppConfig.baseUrl}update_user.php');
      final request = http.MultipartRequest('POST', url);

      // Tambahkan file gambar
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Tambahkan data pengguna lainnya
      request.fields['id'] = userData['id'].toString();
      request.fields['username'] = usernameController.text;
      request.fields['nama_lengkap'] = namaController.text;
      request.fields['email'] = emailController.text;
      request.fields['no_hp'] = hpController.text;
      request.fields['alamat'] = alamatController.text;

      // Kirim request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui')),
          );
          setState(() {
            _userFuture = fetchUser(); // Perbarui data pengguna
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Gagal memperbarui profil'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengunggah gambar')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileScreen.bgColor,
      appBar: AppBar(
        backgroundColor: ProfileScreen.primaryColor,
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          final user = snapshot.data ?? {};
          if (user.isEmpty) {
            return const Center(
              child: Text(
                'Gagal memuat data user',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return _buildProfileForm();
        },
      ),
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: ProfileScreen.accentColor,
                  backgroundImage:
                      profilePictureUrl != null && profilePictureUrl!.isNotEmpty
                      ? (profilePictureUrl!.startsWith('http')
                            ? NetworkImage(profilePictureUrl!)
                            : FileImage(File(profilePictureUrl!))
                                  as ImageProvider)
                      : null,
                  child: profilePictureUrl == null || profilePictureUrl!.isEmpty
                      ? const Icon(Icons.person, color: Colors.white, size: 48)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: pickImage,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _editField(
            label: 'Username',
            icon: Icons.person,
            controller: usernameController,
            validator: (v) =>
                v == null || v.isEmpty ? 'Username wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          _editField(
            label: 'Nama',
            icon: Icons.person,
            controller: namaController,
            validator: (v) =>
                v == null || v.isEmpty ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          _editField(
            label: 'Email',
            icon: Icons.email,
            controller: emailController,
            validator: (v) =>
                v == null || v.isEmpty ? 'Email wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          _editField(
            label: 'No. HP',
            icon: Icons.phone,
            controller: hpController,
            validator: (v) =>
                v == null || v.isEmpty ? 'No. HP wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          _editField(
            label: 'Alamat',
            icon: Icons.home,
            controller: alamatController,
            maxLines: 2,
            validator: (v) =>
                v == null || v.isEmpty ? 'Alamat wajib diisi' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ProfileScreen.accentColor,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.save),
            label: const Text('Simpan Perubahan'),
            onPressed: () {
              setState(() {
                _showError = !_formKey.currentState!.validate();
              });
              if (!_showError) {
                updateUser();
              }
            },
          ),
          if (_showError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Semua field wajib diisi',
                style: TextStyle(color: Colors.red[200]),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _editField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: ProfileScreen.accentColor),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ProfileScreen.accentColor),
        ),
      ),
    );
  }
}
