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

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        final cart = context.read<CartProvider>();
        final orderId = await cart.checkout(
          _customerNameController.text,
          _paymentMethodController.text,
        );

        // Create order for receipt display
        final order = Order(
          id: orderId,
          items: List.from(cart.cartItems),
          totalAmount: cart.totalAmount,
          customerName: _customerNameController.text,
          paymentMethod: _paymentMethodController.text,
          dateTime: DateTime.now(),
        );

        // Show receipt dialog
        if (mounted) {
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
                    Navigator.of(context).popUntil((route) => route.isFirst); // Go back to home
                  },
                  child: const Text('Selesai'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close receipt dialog
                    // Simulate printing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🖨️ Struk berhasil disimpan ke Firebase!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // Then close and go back to home
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // Show error dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Gagal memproses pembayaran: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
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