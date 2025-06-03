import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../config/config.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kontak Kami')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.store, size: 32.0),
                title: Text(
                  'Bengkel Las Sejahtera',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Melayani berbagai kebutuhan las Anda'),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Informasi Kontak',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildContactCard(
              icon: Icons.location_on,
              title: 'Alamat',
              subtitle: 'Jl. Raya Utama No. 123, Kota ABC',
              onTap: () =>
                  _launchUrl('https://maps.google.com/?q=-6.123,106.789'),
            ),
            _buildContactCard(
              icon: Icons.phone,
              title: 'Telepon',
              subtitle: '+62 812-3456-7890',
              onTap: () => _launchUrl('tel:+6281234567890'),
            ),
            _buildContactCard(
              icon: FontAwesomeIcons.whatsapp,
              title: 'WhatsApp',
              subtitle: '+62 812-3456-7890',
              onTap: () => _launchUrl('https://wa.me/6281234567890'),
            ),
            _buildContactCard(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'info@bengkellassejahtera.com',
              onTap: () => _launchUrl('mailto:info@bengkellassejahtera.com'),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Jam Operasional',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildScheduleCard(),
            const SizedBox(height: 24.0),
            _buildSocialMediaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, size: 28.0),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ScheduleRow(day: 'Senin - Jumat', hours: '08:00 - 17:00'),
            ScheduleRow(day: 'Sabtu', hours: '08:00 - 15:00'),
            ScheduleRow(day: 'Minggu', hours: 'Tutup'),
            ScheduleRow(day: 'Hari Libur', hours: 'Tutup'),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Media Sosial',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              icon: Icons.facebook,
              label: 'Facebook',
              onTap: () =>
                  _launchUrl('https://facebook.com/bengkellassejahtera'),
            ),
            _buildSocialButton(
              icon: Icons.camera_alt,
              label: 'Instagram',
              onTap: () =>
                  _launchUrl('https://instagram.com/bengkellassejahtera'),
            ),
            _buildSocialButton(
              icon: Icons.video_library,
              label: 'YouTube',
              onTap: () =>
                  _launchUrl('https://youtube.com/@bengkellassejahtera'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 32.0),
          const SizedBox(height: 4.0),
          Text(label),
        ],
      ),
    );
  }
}

class ScheduleRow extends StatelessWidget {
  final String day;
  final String hours;

  const ScheduleRow({super.key, required this.day, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(day), Text(hours)],
      ),
    );
  }
}

final url = '${AppConfig.baseUrl}get_products.php';
