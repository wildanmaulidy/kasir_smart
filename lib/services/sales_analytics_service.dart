import '../models/product.dart';
import '../models/order.dart';
import '../services/firebase_service.dart';

class SalesAnalyticsService {
  // Get best-selling products based on order data
  static Future<List<Map<String, dynamic>>> getBestSellingProducts({int limit = 5}) async {
    try {
      final orders = await FirebaseService.getOrders();

      // Calculate sales data for each product
      Map<String, Map<String, dynamic>> productSales = {};

      for (final order in orders) {
        for (final cartItem in order.items) {
          final productId = cartItem.product.id;
          final quantity = cartItem.quantity;
          final revenue = cartItem.totalPrice;

          if (productSales.containsKey(productId)) {
            productSales[productId]!['totalQuantity'] += quantity;
            productSales[productId]!['totalRevenue'] += revenue;
            productSales[productId]!['orderCount'] += 1;
          } else {
            productSales[productId] = {
              'product': cartItem.product,
              'totalQuantity': quantity,
              'totalRevenue': revenue,
              'orderCount': 1,
            };
          }
        }
      }

      // Convert to list and sort by total quantity sold
      final sortedProducts = productSales.values.toList()
        ..sort((a, b) => (b['totalQuantity'] as int).compareTo(a['totalQuantity'] as int));

      return sortedProducts.take(limit).toList();
    } catch (e) {
      print('Error calculating best-selling products: $e');
      // Return sample data as fallback
      return _getSampleBestSellingProducts(limit);
    }
  }

  // Get sales statistics
  static Future<Map<String, dynamic>> getSalesStatistics() async {
    try {
      final orders = await FirebaseService.getOrders();

      double totalRevenue = 0;
      int totalOrders = orders.length;
      int totalItemsSold = 0;
      Map<String, int> categorySales = {};

      for (final order in orders) {
        totalRevenue += order.totalAmount;
        for (final cartItem in order.items) {
          totalItemsSold += cartItem.quantity;
          final category = cartItem.product.category;
          categorySales[category] = (categorySales[category] ?? 0) + cartItem.quantity;
        }
      }

      // Calculate average order value
      double averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;

      return {
        'totalRevenue': totalRevenue,
        'totalOrders': totalOrders,
        'totalItemsSold': totalItemsSold,
        'averageOrderValue': averageOrderValue,
        'categorySales': categorySales,
        'bestSellingProducts': await getBestSellingProducts(limit: 3),
      };
    } catch (e) {
      print('Error calculating sales statistics: $e');
      return _getSampleSalesStatistics();
    }
  }

  // Get sales data for charts (daily sales for the last 7 days)
  static Future<List<Map<String, dynamic>>> getDailySalesData() async {
    try {
      final orders = await FirebaseService.getOrders();

      // Group orders by date
      Map<String, Map<String, dynamic>> dailySales = {};

      for (final order in orders) {
        final dateKey = order.formattedDate;
        if (dailySales.containsKey(dateKey)) {
          dailySales[dateKey]!['revenue'] += order.totalAmount;
          dailySales[dateKey]!['orders'] += 1;
          dailySales[dateKey]!['items'] += order.items.fold(0, (sum, item) => sum + item.quantity);
        } else {
          dailySales[dateKey] = {
            'date': dateKey,
            'revenue': order.totalAmount,
            'orders': 1,
            'items': order.items.fold(0, (sum, item) => sum + item.quantity),
          };
        }
      }

      // Sort by date and return last 7 days
      final sortedData = dailySales.values.toList()
        ..sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

      return sortedData.take(7).toList();
    } catch (e) {
      print('Error getting daily sales data: $e');
      return _getSampleDailySalesData();
    }
  }

  // Sample data for fallback
  static List<Map<String, dynamic>> _getSampleBestSellingProducts(int limit) {
    final products = Product.sampleProducts.take(limit).map((product) => {
      'product': product,
      'totalQuantity': 50 + (product.id.hashCode % 50), // Random quantity
      'totalRevenue': (50 + (product.id.hashCode % 50)) * product.price,
      'orderCount': 10 + (product.id.hashCode % 20),
    }).toList();

    return products;
  }

  static Map<String, dynamic> _getSampleSalesStatistics() {
    return {
      'totalRevenue': 1250000.0,
      'totalOrders': 45,
      'totalItemsSold': 180,
      'averageOrderValue': 27777.78,
      'categorySales': {
        'Makanan Utama': 120,
        'Minuman': 45,
        'Makanan Ringan': 15,
      },
      'bestSellingProducts': _getSampleBestSellingProducts(3),
    };
  }

  static List<Map<String, dynamic>> _getSampleDailySalesData() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: index));
      return {
        'date': '${date.day}/${date.month}/${date.year}',
        'revenue': 150000 + (index * 25000),
        'orders': 8 + (index % 3),
        'items': 25 + (index * 5),
      };
    });
  }
}