import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/recommendation_widget.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _getFilteredProducts() {
    List<Product> products = Product.sampleProducts;

    // Filter by category
    if (_selectedCategory != 'Semua') {
      products = products.where((product) => product.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) =>
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
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
      body: Column(
        children: [
          // Search Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              return Container(
                padding: EdgeInsets.all(screenWidth < 400 ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle: TextStyle(
                      fontSize: screenWidth < 400 ? 14 : 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF64748B),
                      size: screenWidth < 400 ? 20 : 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 400 ? 12 : 16,
                      vertical: screenWidth < 400 ? 10 : 12,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: screenWidth < 400 ? 14 : 16,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              );
            },
          ),

          // Category Filter
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              return Container(
                height: screenWidth < 400 ? 45 : 50,
                padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Product.categories.length,
                  itemBuilder: (context, index) {
                    final category = Product.categories[index];
                    final isSelected = category == _selectedCategory;

                    return Container(
                      margin: EdgeInsets.only(right: screenWidth < 400 ? 6 : 8),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            fontSize: screenWidth < 400 ? 12 : 14,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF2563EB).withOpacity(0.1),
                        checkmarkColor: const Color(0xFF2563EB),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: screenWidth < 400 ? 12 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth < 400 ? 8 : 12,
                          vertical: screenWidth < 400 ? 4 : 6,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // AI Recommendations
          const AIRecommendationsWidget(),

          // Products Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive grid layout
                final screenWidth = constraints.maxWidth;
                int crossAxisCount;
                double childAspectRatio;

                if (screenWidth >= 1200) {
                  // Large screens (desktop)
                  crossAxisCount = 4;
                  childAspectRatio = 0.8;
                } else if (screenWidth >= 800) {
                  // Medium screens (tablet)
                  crossAxisCount = 3;
                  childAspectRatio = 0.75;
                } else if (screenWidth >= 600) {
                  // Small tablets
                  crossAxisCount = 2;
                  childAspectRatio = 0.7;
                } else if (screenWidth >= 400) {
                  // Mobile phones (medium)
                  crossAxisCount = 2;
                  childAspectRatio = 0.65;
                } else {
                  // Small mobile phones
                  crossAxisCount = 1;
                  childAspectRatio = 0.75;
                }

                return filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: screenWidth < 400 ? 60 : 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada produk ditemukan',
                            style: TextStyle(
                              fontSize: screenWidth < 400 ? 16 : 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Coba ubah kata kunci pencarian atau kategori',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: screenWidth < 400 ? 14 : 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(screenWidth < 400 ? 12 : 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: screenWidth < 400 ? 12 : 16,
                        mainAxisSpacing: screenWidth < 400 ? 12 : 16,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(product: product);
                      },
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}