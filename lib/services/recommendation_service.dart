import '../models/product.dart';

class RecommendationService {
  static List<Product> getRecommendedProducts() {
    // AI-based recommendation logic
    // For now, return some products based on popularity/popular categories
    final allProducts = Product.sampleProducts;

    // Simple recommendation: return products with high stock and popular categories
    final recommended = allProducts.where((product) =>
      product.stock > 5 &&
      (product.category == 'Makanan Utama' || product.category == 'Minuman')
    ).take(4).toList();

    return recommended.isNotEmpty ? recommended : allProducts.take(4).toList();
  }

  static List<Product> getPersonalizedRecommendations(String userPreference) {
    // More advanced AI recommendation based on user preferences
    final allProducts = Product.sampleProducts;

    return allProducts.where((product) =>
      product.category.toLowerCase().contains(userPreference.toLowerCase()) ||
      product.name.toLowerCase().contains(userPreference.toLowerCase())
    ).take(4).toList();
  }

  static List<Product> getTrendingProducts() {
    // Return products that are "trending" based on some criteria
    final allProducts = Product.sampleProducts;

    // Simple trending logic: products with price between 10000-50000
    return allProducts.where((product) =>
      product.price >= 10000 && product.price <= 50000 && product.stock > 0
    ).take(4).toList();
  }
}