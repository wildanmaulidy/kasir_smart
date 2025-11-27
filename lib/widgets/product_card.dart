import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/checkout_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with TickerProviderStateMixin {
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for hover/press effects
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isSmallCard = cardWidth < 160;

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Container(
                  margin: EdgeInsets.all(isSmallCard ? 4 : 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isSmallCard ? 16 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: isSmallCard ? 15 : 20,
                        offset: Offset(0, isSmallCard ? 6 : 10),
                        spreadRadius: isSmallCard ? 1 : 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: isSmallCard ? 10 : 15,
                        offset: const Offset(-3, -3),
                        spreadRadius: -1,
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
                                  image: NetworkImage(widget.product.imageUrl),
                                  fit: BoxFit.contain,
                                ),
                                // Enhanced image styling for attractiveness
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: isSmallCard ? 8 : 12,
                                    offset: Offset(0, isSmallCard ? 4 : 6),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: isSmallCard ? 4 : 6,
                                    offset: Offset(-2, -2),
                                    spreadRadius: -1,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(isSmallCard ? 16 : 20),
                                    topRight: Radius.circular(isSmallCard ? 16 : 20),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Stock indicator
                                    if (widget.product.stock < 5)
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
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(0.3),
                                                blurRadius: isSmallCard ? 4 : 6,
                                                offset: Offset(0, isSmallCard ? 2 : 3),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'Stok: ${widget.product.stock}',
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
                          ),
                          Padding(
                            padding: EdgeInsets.all(isSmallCard ? 6 : 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
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
                                    color: widget.product.category == 'Makanan Utama'
                                        ? Colors.orange.withOpacity(0.1)
                                        : widget.product.category == 'Minuman'
                                            ? Colors.blue.withOpacity(0.1)
                                            : Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.product.category,
                                    style: TextStyle(
                                      fontSize: isSmallCard ? 9 : 10,
                                      color: widget.product.category == 'Makanan Utama'
                                          ? Colors.orange[300]
                                          : widget.product.category == 'Minuman'
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
                                      currencyFormat.format(widget.product.price),
                                      style: TextStyle(
                                        color: const Color(0xFF3B82F6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmallCard ? 13 : 14,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallCard ? 4 : 6,
                                        vertical: isSmallCard ? 1 : 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget.product.stock > 10
                                            ? Colors.green.withOpacity(0.1)
                                            : widget.product.stock > 5
                                                ? Colors.orange.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${widget.product.stock}',
                                        style: TextStyle(
                                          fontSize: isSmallCard ? 11 : 12,
                                          color: widget.product.stock > 10
                                              ? Colors.green[300]
                                              : widget.product.stock > 5
                                                  ? Colors.orange[300]
                                                  : Colors.red[300],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isSmallCard ? 6 : 8),
                                Row(
                                  children: [
                                    // Add to Cart Button
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: widget.product.stock > 0
                                            ? () {
                                                context.read<CartProvider>().addToCart(widget.product);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('${widget.product.name} ditambahkan ke keranjang'),
                                                    backgroundColor: const Color(0xFFFF6B6B),
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            : null,
                                        child: Icon(
                                          Icons.shopping_cart,
                                          size: isSmallCard ? 16 : 18,
                                          color: widget.product.stock > 0 ? Colors.white : Colors.grey,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: widget.product.stock > 0
                                              ? const Color(0xFFFF6B6B)
                                              : Colors.grey,
                                          padding: EdgeInsets.symmetric(vertical: isSmallCard ? 8 : 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isSmallCard ? 4 : 6),
                                    // Buy Now Button
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: widget.product.stock > 0
                                            ? () {
                                                // Create temporary cart with just this product
                                                final cartProvider = context.read<CartProvider>();
                                                cartProvider.clearCart(); // Clear existing cart
                                                cartProvider.addToCart(widget.product);
                                                // Navigate to checkout
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const CheckoutScreen(),
                                                  ),
                                                );
                                              }
                                            : null,
                                        child: Icon(
                                          Icons.flash_on,
                                          size: isSmallCard ? 16 : 18,
                                          color: widget.product.stock > 0 ? Colors.white : Colors.grey,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: widget.product.stock > 0
                                              ? const Color(0xFF10B981)
                                              : Colors.grey,
                                          padding: EdgeInsets.symmetric(vertical: isSmallCard ? 8 : 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
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
              ),
            );
          },
        );
      },
    );
  }
}