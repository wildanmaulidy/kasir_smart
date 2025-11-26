import '../models/product.dart';
import '../models/order.dart';

class RecommendationService {
  // Get popular products based on order history
  static List<Product> getPopularProducts() {
    final orderCounts = <String, int>{};

    // Count how many times each product has been ordered
    for (final order in Order.sampleOrders) {
      for (final item in order.items) {
        orderCounts[item.product.id] = (orderCounts[item.product.id] ?? 0) + item.quantity;
      }
    }

    // Sort products by popularity
    final sortedProducts = Product.sampleProducts.toList()
      ..sort((a, b) {
        final aCount = orderCounts[a.id] ?? 0;
        final bCount = orderCounts[b.id] ?? 0;
        return bCount.compareTo(aCount);
      });

    return sortedProducts.take(4).toList();
  }

  // Get complementary products (products that go well together)
  static List<Product> getComplementaryProducts(String currentProductId) {
    final complementaryMap = {
      // Nasi Goreng pairs well with drinks
      '1': ['3', '8'], // Nasi Goreng -> Es Teh, Jus Jeruk
      // Ayam Bakar pairs well with rice dishes and drinks
      '2': ['1', '3'], // Ayam Bakar -> Nasi Goreng, Es Teh
      // Drinks pair well with main dishes
      '3': ['1', '2', '4'], // Es Teh -> Nasi Goreng, Ayam Bakar, Bakso
      '8': ['1', '2', '4'], // Jus Jeruk -> Nasi Goreng, Ayam Bakar, Bakso
      // Bakso pairs well with drinks
      '4': ['3', '8'], // Bakso -> Es Teh, Jus Jeruk
      // Sate pairs well with drinks
      '5': ['3', '8'], // Sate Ayam -> Es Teh, Jus Jeruk
      // Rendang pairs well with rice
      '6': ['1'], // Rendang -> Nasi Goreng
      // Gado-gado pairs well with drinks
      '7': ['3', '8'], // Gado-Gado -> Es Teh, Jus Jeruk
    };

    final complementaryIds = complementaryMap[currentProductId] ?? [];
    return Product.sampleProducts
        .where((product) => complementaryIds.contains(product.id))
        .toList();
  }

  // Get personalized recommendations based on cart contents
  static List<Product> getPersonalizedRecommendations(List<String> cartProductIds) {
    final recommendations = <Product>[];

    // Get complementary products for items in cart
    for (final productId in cartProductIds) {
      final complementary = getComplementaryProducts(productId);
      for (final product in complementary) {
        if (!cartProductIds.contains(product.id) && !recommendations.contains(product)) {
          recommendations.add(product);
        }
      }
    }

    // If no complementary products, return popular products
    if (recommendations.isEmpty) {
      recommendations.addAll(getPopularProducts());
    }

    return recommendations.take(3).toList();
  }

  // Get trending products (recently popular)
  static List<Product> getTrendingProducts() {
    // For demo purposes, return products with high ratings or recent popularity
    return Product.sampleProducts.where((product) {
      // Simulate trending based on product ID (even IDs are trending)
      return int.parse(product.id) % 2 == 0;
    }).take(3).toList();
  }

  // AI-powered recommendations based on user behavior patterns
  static List<Product> getAIRecommendations({
    required List<String> viewedProducts,
    required List<String> cartProductIds,
    required List<Order> userOrderHistory,
  }) {
    final recommendations = <Product>[];
    final scores = <String, double>{};

    // Initialize scores for all products
    for (final product in Product.sampleProducts) {
      scores[product.id] = 0.0;
    }

    // Boost score for complementary products (40% weight)
    for (final productId in cartProductIds) {
      final complementary = getComplementaryProducts(productId);
      for (final compProduct in complementary) {
        if (!cartProductIds.contains(compProduct.id)) {
          scores[compProduct.id] = (scores[compProduct.id] ?? 0) + 0.4;
        }
      }
    }

    // Boost score for popular products (30% weight)
    final popularProducts = getPopularProducts();
    for (final product in popularProducts) {
      if (!cartProductIds.contains(product.id)) {
        scores[product.id] = (scores[product.id] ?? 0) + 0.3;
      }
    }

    // Boost score for trending products (20% weight)
    final trendingProducts = getTrendingProducts();
    for (final product in trendingProducts) {
      if (!cartProductIds.contains(product.id)) {
        scores[product.id] = (scores[product.id] ?? 0) + 0.2;
      }
    }

    // Boost score for frequently ordered items from history (10% weight)
    final userProductCounts = <String, int>{};
    for (final order in userOrderHistory) {
      for (final item in order.items) {
        userProductCounts[item.product.id] = (userProductCounts[item.product.id] ?? 0) + item.quantity;
      }
    }

    final maxUserOrders = userProductCounts.values.isNotEmpty ? userProductCounts.values.reduce((a, b) => a > b ? a : b) : 1;
    for (final entry in userProductCounts.entries) {
      final normalizedScore = (entry.value / maxUserOrders) * 0.1;
      scores[entry.key] = (scores[entry.key] ?? 0) + normalizedScore;
    }

    // Sort by score and return top recommendations
    final sortedProducts = Product.sampleProducts.where((product) =>
      !cartProductIds.contains(product.id)
    ).toList()
      ..sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));

    return sortedProducts.take(4).toList();
  }
}