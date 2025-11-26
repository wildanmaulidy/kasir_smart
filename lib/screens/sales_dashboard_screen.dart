import 'package:flutter/material.dart';
import '../services/sales_analytics_service.dart';
import '../widgets/best_selling_card.dart';

class SalesDashboardScreen extends StatefulWidget {
  const SalesDashboardScreen({super.key});

  @override
  State<SalesDashboardScreen> createState() => _SalesDashboardScreenState();
}

class _SalesDashboardScreenState extends State<SalesDashboardScreen> {
  Map<String, dynamic>? _salesStats;
  List<Map<String, dynamic>>? _bestSellingProducts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    try {
      final stats = await SalesAnalyticsService.getSalesStatistics();
      final bestSelling = await SalesAnalyticsService.getBestSellingProducts(limit: 10);

      setState(() {
        _salesStats = stats;
        _bestSellingProducts = bestSelling;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading sales data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Penjualan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSalesData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sales Statistics Cards
                  const Text(
                    '📊 Statistik Penjualan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticsGrid(),

                  const SizedBox(height: 32),

                  // Best Selling Products
                  const Text(
                    '🏆 Makanan Terlaris',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBestSellingProducts(),

                  const SizedBox(height: 32),

                  // Category Sales
                  const Text(
                    '📈 Penjualan per Kategori',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategorySales(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticsGrid() {
    if (_salesStats == null) return const SizedBox();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          '💰 Total Pendapatan',
          'Rp ${_salesStats!['totalRevenue'].toStringAsFixed(0)}',
          Colors.green,
          Icons.attach_money,
        ),
        _buildStatCard(
          '📦 Total Pesanan',
          '${_salesStats!['totalOrders']} pesanan',
          Colors.blue,
          Icons.shopping_cart,
        ),
        _buildStatCard(
          '🍽️ Item Terjual',
          '${_salesStats!['totalItemsSold']} item',
          Colors.orange,
          Icons.fastfood,
        ),
        _buildStatCard(
          '📊 Rata-rata Pesanan',
          'Rp ${_salesStats!['averageOrderValue'].toStringAsFixed(0)}',
          Colors.purple,
          Icons.analytics,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellingProducts() {
    if (_bestSellingProducts == null || _bestSellingProducts!.isEmpty) {
      return const Center(
        child: Text('Belum ada data penjualan'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bestSellingProducts!.length,
      itemBuilder: (context, index) {
        final productData = _bestSellingProducts![index];
        return BestSellingCard(
          product: productData['product'],
          totalQuantity: productData['totalQuantity'],
          totalRevenue: productData['totalRevenue'],
          orderCount: productData['orderCount'],
          rank: index + 1,
        );
      },
    );
  }

  Widget _buildCategorySales() {
    if (_salesStats == null) return const SizedBox();

    final categorySales = _salesStats!['categorySales'] as Map<String, int>;

    return Column(
      children: categorySales.entries.map((entry) {
        final percentage = (_salesStats!['totalItemsSold'] as int) > 0
            ? (entry.value / (_salesStats!['totalItemsSold'] as int)) * 100
            : 0.0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${entry.value} item',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getCategoryColor(entry.key),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${percentage.toStringAsFixed(1)}% dari total penjualan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan Utama':
        return Colors.orange;
      case 'Minuman':
        return Colors.blue;
      case 'Makanan Ringan':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}