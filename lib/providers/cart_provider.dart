import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../services/firebase_service.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].incrementQuantity();
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeFromCart(productId);
      } else {
        _cartItems[index].quantity = quantity;
        notifyListeners();
      }
    }
  }

  void incrementQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cartItems[index].incrementQuantity();
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cartItems[index].decrementQuantity();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<String> checkout(String customerName, String paymentMethod) async {
    try {
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: _cartItems,
        totalAmount: totalAmount,
        customerName: customerName,
        paymentMethod: paymentMethod,
        dateTime: DateTime.now(),
      );

      final orderId = await FirebaseService.createOrder(order);
      clearCart();
      return orderId;
    } catch (e) {
      throw Exception('Failed to process order: $e');
    }
  }
}