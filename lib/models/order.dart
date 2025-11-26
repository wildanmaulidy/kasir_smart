import 'cart_item.dart';
import 'product.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String customerName;
  final String paymentMethod;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.customerName,
    required this.paymentMethod,
    required this.dateTime,
  });

  String get formattedDate => '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  String get formattedTime => '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

  // Sample order history
  static List<Order> sampleOrders = [
    Order(
      id: 'ORD001',
      items: [
        CartItem(product: Product.sampleProducts[0], quantity: 2),
        CartItem(product: Product.sampleProducts[2], quantity: 1),
      ],
      totalAmount: 55000,
      customerName: 'John Doe',
      paymentMethod: 'Tunai',
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Order(
      id: 'ORD002',
      items: [
        CartItem(product: Product.sampleProducts[3], quantity: 1),
        CartItem(product: Product.sampleProducts[2], quantity: 3),
      ],
      totalAmount: 19000,
      customerName: 'Jane Smith',
      paymentMethod: 'Transfer',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}