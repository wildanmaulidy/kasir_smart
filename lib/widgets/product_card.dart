import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isSmallCard = cardWidth < 160;

        return Container(
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
                    Colors.white,
                    const Color(0xFFF8FAFC),
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
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: isSmallCard ? 6 : 10,
                            offset: Offset(0, isSmallCard ? 3 : 5),
                          ),
                        ],
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.3),
                                        blurRadius: isSmallCard ? 4 : 6,
                                        offset: Offset(0, isSmallCard ? 2 : 3),
                                      ),
                                    ],
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
                  ),
                  Padding(
                    padding: EdgeInsets.all(isSmallCard ? 8 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallCard ? 14 : 16,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isSmallCard ? 3 : 4),
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
                                  ? Colors.orange[700]
                                  : product.category == 'Minuman'
                                      ? Colors.blue[700]
                                      : Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallCard ? 6 : 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp ${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: const Color(0xFF059669),
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
                                color: product.stock > 10
                                    ? Colors.green.withOpacity(0.1)
                                    : product.stock > 5
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${product.stock}',
                                style: TextStyle(
                                  fontSize: isSmallCard ? 11 : 12,
                                  color: product.stock > 10
                                      ? Colors.green[700]
                                      : product.stock > 5
                                          ? Colors.orange[700]
                                          : Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallCard ? 8 : 12),
                        Container(
                          width: double.infinity,
                          height: isSmallCard ? 32 : 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: product.stock > 0
                                  ? [const Color(0xFF2563EB), const Color(0xFF1D4ED8)]
                                  : [Colors.grey, Colors.grey[400]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: product.stock > 0
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF2563EB).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: ElevatedButton(
                            onPressed: product.stock > 0
                                ? () {
                                    context.read<CartProvider>().addToCart(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} ditambahkan ke keranjang'),
                                        backgroundColor: const Color(0xFF2563EB),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              product.stock > 0 ? 'Tambah' : 'Habis',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallCard ? 13 : 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}