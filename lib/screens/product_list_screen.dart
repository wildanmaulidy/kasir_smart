import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String? initialSearchQuery;

  const ProductListScreen({super.key, this.initialSearchQuery});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _selectedCategory = 'Semua';
  late String _searchQuery;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialSearchQuery ?? '';
    _searchController.text = _searchQuery;
  }

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
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Daftar Produk',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  color: const Color(0xFF1E293B),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth < 400 ? 14 : 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF94A3B8).withOpacity(0.7),
                      fontSize: screenWidth < 400 ? 14 : 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF94A3B8).withOpacity(0.7),
                      size: screenWidth < 400 ? 20 : 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF334155),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 400 ? 12 : 16,
                      vertical: screenWidth < 400 ? 10 : 12,
                    ),
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
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                ),
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
                        backgroundColor: const Color(0xFF334155),
                        selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF3B82F6),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: screenWidth < 400 ? 12 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF475569),
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