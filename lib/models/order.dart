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

  String get formattedDate {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year}';
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => {
        'productId': item.product.id,
        'productName': item.product.name,
        'quantity': item.quantity,
        'price': item.product.price,
        'totalPrice': item.totalPrice,
      }).toList(),
      'totalAmount': totalAmount,
      'customerName': customerName,
      'paymentMethod': paymentMethod,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create from Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      items: (map['items'] as List).map((item) => CartItem(
        product: Product( // We'll need to create a simple product from the data
          id: item['productId'],
          name: item['productName'],
          price: item['price'],
          category: 'Unknown', // Default category
          description: '',
          imageUrl: '', // Default empty image
          stock: 0, // Default stock
        ),
        quantity: item['quantity'],
      )).toList(),
      totalAmount: map['totalAmount'],
      customerName: map['customerName'],
      paymentMethod: map['paymentMethod'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}