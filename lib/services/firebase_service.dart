import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/order.dart' as order_model;
import '../models/cart_item.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Products Collection
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String usersCollection = 'users';

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Authentication methods
  static Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Products CRUD operations
  static Future<List<Product>> getProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(productsCollection)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          stock: data['stock'] ?? 0,
          category: data['category'] ?? 'Lainnya',
        );
      }).toList();
    } catch (e) {
      print('Error getting products: $e');
      // Return sample data as fallback
      return Product.sampleProducts;
    }
  }

  static Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection(productsCollection).add({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'stock': product.stock,
        'category': product.category,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  static Future<void> updateProduct(String productId, Product product) async {
    try {
      await _firestore.collection(productsCollection).doc(productId).update({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'stock': product.stock,
        'category': product.category,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  static Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(productsCollection).doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }

  // Orders CRUD operations
  static Future<String> createOrder(order_model.Order order) async {
    try {
      final orderData = {
        'id': order.id,
        'customerName': order.customerName,
        'paymentMethod': order.paymentMethod,
        'totalAmount': order.totalAmount,
        'dateTime': Timestamp.fromDate(order.dateTime),
        'userId': currentUser?.uid ?? 'anonymous',
        'items': order.items.map((item) => {
          'productId': item.product.id,
          'productName': item.product.name,
          'quantity': item.quantity,
          'price': item.product.price,
          'totalPrice': item.totalPrice,
        }).toList(),
      };

      final docRef = await _firestore.collection(ordersCollection).add(orderData);
      return docRef.id;
    } catch (e) {
      print('Error creating order: $e');
      throw e;
    }
  }

  static Future<List<order_model.Order>> getOrders({String? userId}) async {
    try {
      Query query = _firestore.collection(ordersCollection);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final QuerySnapshot snapshot = await query
          .orderBy('dateTime', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final items = (data['items'] as List<dynamic>).map((itemData) {
          final itemMap = itemData as Map<String, dynamic>;
          // Create a basic product for the cart item
          final product = Product(
            id: itemMap['productId'] ?? '',
            name: itemMap['productName'] ?? '',
            description: '',
            price: (itemMap['price'] ?? 0).toDouble(),
            imageUrl: '',
            stock: 0,
            category: '',
          );
          return CartItem(
            product: product,
            quantity: itemMap['quantity'] ?? 1,
          );
        }).toList();

        return order_model.Order(
          id: data['id'] ?? doc.id,
          items: items,
          totalAmount: (data['totalAmount'] ?? 0).toDouble(),
          customerName: data['customerName'] ?? '',
          paymentMethod: data['paymentMethod'] ?? '',
          dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('Error getting orders: $e');
      // Return sample orders as fallback
      return order_model.Order.sampleOrders;
    }
  }

  // Real-time listeners
  static Stream<List<Product>> getProductsStream() {
    return _firestore
        .collection(productsCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Product(
              id: doc.id,
              name: data['name'] ?? '',
              description: data['description'] ?? '',
              price: (data['price'] ?? 0).toDouble(),
              imageUrl: data['imageUrl'] ?? '',
              stock: data['stock'] ?? 0,
              category: data['category'] ?? 'Lainnya',
            );
          }).toList();
        });
  }

  static Stream<List<order_model.Order>> getOrdersStream({String? userId}) {
    Query query = _firestore.collection(ordersCollection);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final docData = doc.data() as Map<String, dynamic>;
            final itemsData = docData['items'] as List<dynamic>? ?? [];
            final items = itemsData.map((itemData) {
              final itemMap = itemData as Map<String, dynamic>;
              final product = Product(
                id: itemMap['productId'] ?? '',
                name: itemMap['productName'] ?? '',
                description: '',
                price: (itemMap['price'] ?? 0).toDouble(),
                imageUrl: '',
                stock: 0,
                category: '',
              );
              return CartItem(
                product: product,
                quantity: itemMap['quantity'] ?? 1,
              );
            }).toList();

            return order_model.Order(
              id: docData['id'] ?? doc.id,
              items: items,
              totalAmount: (docData['totalAmount'] ?? 0).toDouble(),
              customerName: docData['customerName'] ?? '',
              paymentMethod: docData['paymentMethod'] ?? '',
              dateTime: (docData['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
            );
          }).toList();
        });
  }

  // Initialize sample data (for development)
  static Future<void> initializeSampleData() async {
    try {
      // Check if products already exist
      final productsSnapshot = await _firestore.collection(productsCollection).get();
      if (productsSnapshot.docs.isEmpty) {
        // Add sample products
        for (final product in Product.sampleProducts) {
          await addProduct(product);
        }
        print('Sample products initialized');
      }

      // Check if orders already exist
      final ordersSnapshot = await _firestore.collection(ordersCollection).get();
      if (ordersSnapshot.docs.isEmpty) {
        // Add sample orders
        for (final order in order_model.Order.sampleOrders) {
          await createOrder(order);
        }
        print('Sample orders initialized');
      }
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}