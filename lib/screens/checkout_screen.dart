import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/order.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _paymentMethodController = TextEditingController(text: 'Tunai');

  @override
  void dispose() {
    _customerNameController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      final cart = context.read<CartProvider>();
      final total = cart.totalAmount;

      // Create order
      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      final order = Order(
        id: orderId,
        items: List.from(cart.cartItems), // Copy cart items
        totalAmount: total,
        customerName: _customerNameController.text,
        paymentMethod: _paymentMethodController.text,
        dateTime: DateTime.now(),
      );

      // Add to sample orders (in a real app, this would be saved to database)
      Order.sampleOrders.insert(0, order);

      // Show receipt dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🧾 Struk Pembayaran'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'KASIR SMART',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Divider(),
                Text('Order ID: ${order.id}'),
                Text('Tanggal: ${order.formattedDate} ${order.formattedTime}'),
                Text('Pelanggan: ${order.customerName}'),
                Text('Pembayaran: ${order.paymentMethod}'),
                const Divider(),
                const Text('Detail Pesanan:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${item.quantity}x ${item.product.name}'),
                      ),
                      Text('Rp ${item.totalPrice.toStringAsFixed(0)}'),
                    ],
                  ),
                )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      'Rp ${order.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Terima Kasih Atas Kunjungannya!',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                cart.clearCart(); // Clear cart
                Navigator.of(context).popUntil((route) => route.isFirst); // Go back to home

                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Pembayaran berhasil! Struk telah dicetak.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Selesai'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close receipt dialog
                // Simulate printing
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🖨️ Struk sedang dicetak...'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Then close and clear cart
                Future.delayed(const Duration(seconds: 2), () {
                  cart.clearCart();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Pembayaran berhasil!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              },
              child: const Text('Cetak Struk'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...cart.cartItems.map((item) => ListTile(
                    title: Text(item.product.name),
                    subtitle: Text('${item.quantity} x Rp ${item.product.price.toStringAsFixed(0)}'),
                    trailing: Text('Rp ${item.totalPrice.toStringAsFixed(0)}'),
                  )),
              const Divider(),
              ListTile(
                title: const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  'Rp ${cart.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Informasi Pelanggan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pelanggan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(
                  labelText: 'Metode Pembayaran',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Metode pembayaran harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Proses Pembayaran',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}