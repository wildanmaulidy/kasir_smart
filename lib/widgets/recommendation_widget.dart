import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/recommendation_service.dart';
import '../screens/checkout_screen.dart';

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({super.key});

  @override
  State<RecommendationWidget> createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  late List<Product> _recommendedProducts;

  @override
  void initState() {
    super.initState();
    _recommendedProducts = RecommendationService.getRecommendedProducts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: padding),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6366F1).withOpacity(0.8),
            const Color(0xFF8B5CF6).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Produk Unggulan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Produk unggulan berdasarkan rekomendasi AI',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // Horizontal scrolling recommended products
          SizedBox(
            height: screenWidth < 400 ? 200 : 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendedProducts.length,
              itemBuilder: (context, index) {
                final product = _recommendedProducts[index];
                return Container(
                  width: screenWidth < 400 ? 160 : 180,
                  margin: EdgeInsets.only(
                    right: index < _recommendedProducts.length - 1 ? 12 : 0,
                  ),
                  child: _buildRecommendedProductCard(context, product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProductCard(BuildContext context, Product product) {
    final cardWidth = MediaQuery.of(context).size.width < 400 ? 160 : 180;
    final isSmallCard = cardWidth < 170;

    return GestureDetector(
      onTap: () {
        // Navigate to product detail or add to cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} - Rekomendasi AI!'),
            backgroundColor: const Color(0xFF6366F1),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(isSmallCard ? 4 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isSmallCard ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: isSmallCard ? 15 : 20,
              offset: Offset(0, isSmallCard ? 6 : 10),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallCard ? 16 : 20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallCard ? 16 : 20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isSmallCard ? 16 : 20),
                        topRight: Radius.circular(isSmallCard ? 16 : 20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: isSmallCard ? 8 : 12,
                          offset: Offset(0, isSmallCard ? 4 : 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // AI recommendation badge
                        Positioned(
                          top: isSmallCard ? 6 : 8,
                          left: isSmallCard ? 6 : 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallCard ? 6 : 8,
                              vertical: isSmallCard ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                              ),
                              borderRadius: BorderRadius.circular(isSmallCard ? 8 : 12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF06B6D4).withOpacity(0.3),
                                  blurRadius: isSmallCard ? 4 : 6,
                                  offset: Offset(0, isSmallCard ? 2 : 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.smart_toy,
                                  color: Colors.white,
                                  size: isSmallCard ? 10 : 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'AI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallCard ? 8 : 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Stock indicator
                        if (product.stock < 5)
                          Positioned(
                            top: isSmallCard ? 6 : 8,
                            right: isSmallCard ? 6 : 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallCard ? 6 : 8,
                                vertical: isSmallCard ? 2 : 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(isSmallCard ? 8 : 12),
                              ),
                              child: Text(
                                'Stok: ${product.stock}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallCard ? 8 : 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(isSmallCard ? 6 : 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallCard ? 14 : 16,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallCard ? 2 : 3),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallCard ? 6 : 8,
                          vertical: isSmallCard ? 2 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: product.category == 'Makanan Utama'
                              ? Colors.orange.withOpacity(0.1)
                              : product.category == 'Minuman'
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: isSmallCard ? 9 : 10,
                            color: product.category == 'Makanan Utama'
                                ? Colors.orange[300]
                                : product.category == 'Minuman'
                                    ? Colors.blue[300]
                                    : Colors.green[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallCard ? 4 : 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\Rp${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: TextStyle(
                              color: const Color(0xFF3B82F6),
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallCard ? 13 : 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallCard ? 6 : 8),
                      // Quick action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: product.stock > 0
                                  ? () {
                                      context.read<CartProvider>().addToCart(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${product.name} ditambahkan ke keranjang'),
                                          backgroundColor: const Color(0xFFFF6B6B),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Icon(
                                Icons.shopping_cart,
                                size: isSmallCard ? 14 : 16,
                                color: product.stock > 0 ? Colors.white : Colors.grey,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: product.stock > 0
                                    ? const Color(0xFFFF6B6B)
                                    : Colors.grey,
                                padding: EdgeInsets.symmetric(vertical: isSmallCard ? 6 : 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallCard ? 4 : 6),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: product.stock > 0
                                  ? () {
                                      final cartProvider = context.read<CartProvider>();
                                      cartProvider.clearCart();
                                      cartProvider.addToCart(product);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CheckoutScreen(),
                                        ),
                                      );
                                    }
                                  : null,
                              icon: Icon(
                                Icons.flash_on,
                                size: isSmallCard ? 14 : 16,
                                color: product.stock > 0 ? Colors.white : Colors.grey,
                              ),
                              label: Text(
                                'Beli',
                                style: TextStyle(
                                  fontSize: isSmallCard ? 11 : 12,
                                  color: product.stock > 0 ? Colors.white : Colors.grey,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: product.stock > 0
                                    ? const Color(0xFF10B981)
                                    : Colors.grey,
                                padding: EdgeInsets.symmetric(vertical: isSmallCard ? 6 : 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
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
        ),
      ),
    );
  }
}