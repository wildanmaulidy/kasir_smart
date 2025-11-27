import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import '../screens/product_list_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/flash_sale_screen.dart';
import '../screens/free_shipping_screen.dart';
import '../screens/warranty_screen.dart';
import '../screens/help_screen.dart';
import '../models/product.dart';
import '../widgets/animated_background.dart';
import '../widgets/recommendation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Logo and Actions
                  _buildHeader(),

                  // Hero Banner
                  _buildHeroBanner(),

                  const SizedBox(height: 16),

                  // Quick Actions
                  _buildQuickActions(),

                  const SizedBox(height: 12),

                  // Search Bar
                  _buildSearchBar(),

                  const SizedBox(height: 12),

                  // Statistics Section
                  _buildStatisticsSection(),

                  const SizedBox(height: 12),

                  // Featured Categories
                  _buildFeaturedCategories(),

                  const SizedBox(height: 12),

                  // AI Recommendations
                  const RecommendationWidget(),

                  const SizedBox(height: 12),

                  // Special Offers
                  _buildSpecialOffers(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0; // Smaller padding for more compact design
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.store,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KASIR SMART',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Belanja Mudah & Cepat',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                  );
                },
              ),
              Consumer<CartProvider>(
                builder: (context, cart, child) => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
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
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth < 400 ? 140.0 : 160.0; // Smaller height for more compact design
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 16 : 20),
      height: bannerHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Temukan produk terbaik dengan harga terjangkau',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Mulai Belanja',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            icon: Icons.flash_on,
            label: 'Flash Sale',
            color: const Color(0xFFFF6B6B),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FlashSaleScreen()),
              );
            },
          ),
          _buildQuickActionButton(
            icon: Icons.local_shipping,
            label: 'Gratis Ongkir',
            color: const Color(0xFF4ECDC4),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FreeShippingScreen()),
              );
            },
          ),
          _buildQuickActionButton(
            icon: Icons.verified,
            label: 'Garansi',
            color: const Color(0xFF45B7D1),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WarrantyScreen()),
              );
            },
          ),
          _buildQuickActionButton(
            icon: Icons.support_agent,
            label: 'Bantuan',
            color: const Color(0xFFF9CA24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth < 400 ? 50.0 : 60.0; // Smaller buttons for small screens
    final iconSize = screenWidth < 400 ? 24.0 : 28.0;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 400 ? 12.0 : 16.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Cari produk favorit Anda...',
            hintStyle: TextStyle(color: const Color(0xFF94A3B8).withOpacity(0.7)),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: const Color(0xFF94A3B8).withOpacity(0.7)),
            suffixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard('1000+', 'Produk', Icons.inventory),
          _buildStatCard('500+', 'Pelanggan', Icons.people),
          _buildStatCard('4.8', 'Rating', Icons.star),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF3B82F6),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCategories() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 400 ? 12.0 : 16.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategori Populer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductListScreen()),
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(color: Color(0xFF3B82F6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: screenWidth < 400 ? 80.0 : 100.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryCard('Elektronik', Icons.devices, const Color(0xFF3B82F6), 'assets/images/electronics.jpg'),
                _buildCategoryCard('Fashion', Icons.checkroom, const Color(0xFF8B5CF6), 'assets/images/fashion.jpg'),
                _buildCategoryCard('Rumah Tangga', Icons.home, const Color(0xFF10B981), 'assets/images/home.jpg'),
                _buildCategoryCard('Olahraga', Icons.sports_soccer, const Color(0xFFF59E0B), 'assets/images/sports.jpg'),
                _buildCategoryCard('Kesehatan', Icons.health_and_safety, const Color(0xFFEF4444), 'assets/images/health.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color, String imagePath) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 400 ? 80.0 : 100.0;
    final cardHeight = screenWidth < 400 ? 80.0 : 100.0;
    final iconSize = screenWidth < 400 ? 28.0 : 32.0;
    final marginRight = screenWidth < 400 ? 12.0 : 16.0;
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: marginRight),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductListScreen()),
          );
        },
        child: Column(
          children: [
            Container(
              width: cardHeight,
              height: cardHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
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
          ],
        ),
      ),
    );
  }


  Widget _buildEnhancedProductCard(BuildContext context, Product product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isSmallCard = cardWidth < 160;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductListScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(isSmallCard ? 12 : 16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: isSmallCard ? 6 : 8,
                  offset: Offset(0, isSmallCard ? 3 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with Gradient Overlay
                Stack(
                  children: [
                    Container(
                      height: isSmallCard ? 100 : 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSmallCard ? 12 : 16),
                          topRight: Radius.circular(isSmallCard ? 12 : 16),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: isSmallCard ? 100 : 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSmallCard ? 12 : 16),
                          topRight: Radius.circular(isSmallCard ? 12 : 16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: isSmallCard ? 6 : 8,
                      right: isSmallCard ? 6 : 8,
                      child: Container(
                        padding: EdgeInsets.all(isSmallCard ? 4 : 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(isSmallCard ? 16 : 20),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: isSmallCard ? 12 : 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(isSmallCard ? 8 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallCard ? 12 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallCard ? 2 : 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFF59E0B),
                            size: isSmallCard ? 14 : 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.${product.id}',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: isSmallCard ? 10 : 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallCard ? 6 : 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currencyFormat.format(product.price),
                            style: TextStyle(
                              color: const Color(0xFF3B82F6),
                              fontSize: isSmallCard ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(isSmallCard ? 6 : 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              ),
                              borderRadius: BorderRadius.circular(isSmallCard ? 6 : 8),
                            ),
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: isSmallCard ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecialOffers() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth < 400 ? 12.0 : 16.0;
    final padding = screenWidth < 400 ? 16.0 : 20.0;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'LIMITED TIME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Diskon Hingga 70%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Penawaran spesial untuk produk pilihan',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Belanja Sekarang',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth < 400 ? 80 : 100,
            height: screenWidth < 400 ? 80 : 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer,
              color: Colors.white,
              size: screenWidth < 400 ? 40 : 50,
            ),
          ),
        ],
      ),
    );
  }

}