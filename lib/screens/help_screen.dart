import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/animated_background.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '💬 Bantuan & Dukungan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF9CA24), Color(0xFFF093FB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF9CA24).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.support_agent,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Butuh Bantuan?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kami siap membantu Anda 24/7',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Contact Options
                  const Text(
                    'Hubungi Kami',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // WhatsApp
                  _buildContactCard(
                    icon: Icons.message,
                    title: 'WhatsApp',
                    subtitle: '+62 812-3456-7890',
                    color: const Color(0xFF25D366),
                    onTap: () => _launchWhatsApp(),
                  ),

                  const SizedBox(height: 12),

                  // Phone
                  _buildContactCard(
                    icon: Icons.phone,
                    title: 'Telepon',
                    subtitle: '(021) 1234-5678',
                    color: const Color(0xFF007AFF),
                    onTap: () => _launchPhone(),
                  ),

                  const SizedBox(height: 12),

                  // Email
                  _buildContactCard(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'support@kasirsmart.com',
                    color: const Color(0xFFEA4335),
                    onTap: () => _launchEmail(),
                  ),

                  const SizedBox(height: 30),

                  // FAQ Section
                  const Text(
                    'Pertanyaan Umum',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildFAQCard(
                    question: 'Bagaimana cara memesan produk?',
                    answer: 'Pilih produk yang diinginkan, tambahkan ke keranjang, lalu lakukan checkout dan pembayaran.',
                  ),

                  const SizedBox(height: 12),

                  _buildFAQCard(
                    question: 'Berapa lama pengiriman?',
                    answer: 'Pengiriman dalam 1-3 hari kerja untuk wilayah Jabodetabek, dan 3-7 hari untuk luar Jabodetabek.',
                  ),

                  const SizedBox(height: 12),

                  _buildFAQCard(
                    question: 'Apakah ada garansi produk?',
                    answer: 'Ya, produk elektronik memiliki garansi resmi 1-2 tahun sesuai ketentuan pabrikan.',
                  ),

                  const SizedBox(height: 12),

                  _buildFAQCard(
                    question: 'Bagaimana cara refund?',
                    answer: 'Refund dapat dilakukan dalam 7 hari setelah menerima produk dengan syarat produk dalam kondisi baik.',
                  ),

                  const SizedBox(height: 30),

                  // Store Information
                  const Text(
                    'Informasi Toko',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.store,
                              color: const Color(0xFF3B82F6),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'KASIR SMART',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.location_on, 'Jl. Teknologi No. 123, Jakarta'),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.access_time, 'Senin - Minggu: 08.00 - 22.00 WIB'),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.language, 'www.kasirsmart.com'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Social Media
                  const Text(
                    'Ikuti Kami',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: Icons.facebook,
                        color: const Color(0xFF1877F2),
                        onTap: () => _launchURL('https://facebook.com/kasirsmart'),
                      ),
                      _buildSocialButton(
                        icon: Icons.camera_alt,
                        color: const Color(0xFFE4405F),
                        onTap: () => _launchURL('https://instagram.com/kasirsmart'),
                      ),
                      _buildSocialButton(
                        icon: Icons.play_arrow,
                        color: const Color(0xFFFF0000),
                        onTap: () => _launchURL('https://youtube.com/kasirsmart'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard({required String question, required String answer}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF3B82F6),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _launchWhatsApp() async {
    const phoneNumber = '+6281234567890';
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchPhone() async {
    const phoneNumber = '+622112345678';
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchEmail() async {
    const email = 'support@kasirsmart.com';
    final url = 'mailto:$email?subject=Bantuan Kasir Smart';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}