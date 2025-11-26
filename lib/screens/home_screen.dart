import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/product_list_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/sales_dashboard_screen.dart';
import '../screens/order_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Smart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2FE),
              Color(0xFFBBDEFB),
              Color(0xFF90CAF9),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;
            final padding = isSmallScreen ? 16.0 : 24.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isSmallScreen ? double.infinity : 500,
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: isSmallScreen ? 60 : 80,
                            color: const Color(0xFF2563EB),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Selamat Datang di Kasir Smart',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 24 : 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Kelola penjualan restoran dengan mudah dan cepat. Tambahkan produk ke keranjang dan proses pembayaran dalam hitungan detik.',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: const Color(0xFF64748B),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity,
                            height: isSmallScreen ? 45 : 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProductListScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Mulai Berjualan',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 40),
                    isSmallScreen
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFeatureCard(
                                  icon: Icons.inventory,
                                  title: 'Manajemen Produk',
                                  description: 'Kelola menu dengan mudah',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ProductListScreen()),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildFeatureCard(
                                  icon: Icons.shopping_cart,
                                  title: 'Keranjang Pintar',
                                  description: 'Tambah & kelola pesanan',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CartScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFeatureCard(
                                  icon: Icons.receipt,
                                  title: 'Riwayat Pesanan',
                                  description: 'Lihat pesanan sebelumnya',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildFeatureCard(
                                  icon: Icons.analytics,
                                  title: 'Dashboard Penjualan',
                                  description: 'Lihat makanan terlaris',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SalesDashboardScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureCard(
                              icon: Icons.inventory,
                              title: 'Manajemen Produk',
                              description: 'Kelola menu dengan mudah',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProductListScreen()),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildFeatureCard(
                              icon: Icons.shopping_cart,
                              title: 'Keranjang Pintar',
                              description: 'Tambah & kelola pesanan',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CartScreen()),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildFeatureCard(
                              icon: Icons.receipt,
                              title: 'Riwayat Pesanan',
                              description: 'Lihat pesanan sebelumnya',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildFeatureCard(
                              icon: Icons.smart_toy,
                              title: 'AI Rekomendasi',
                              description: 'Saran produk cerdas',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProductListScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        final cardWidth = isSmallScreen ? 90.0 : 110.0;
        final iconSize = isSmallScreen ? 20.0 : 24.0;
        final titleSize = isSmallScreen ? 11.0 : 12.0;
        final descSize = isSmallScreen ? 9.0 : 10.0;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: cardWidth,
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFF8FAFC),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 12,
                  offset: const Offset(-4, -4),
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2563EB).withOpacity(0.8),
                        const Color(0xFF1D4ED8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                    shadows: const [
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 3 : 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: descSize,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}