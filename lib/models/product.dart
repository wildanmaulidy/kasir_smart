class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;
  final String category;
  final double? discountPercentage; // For flash sale
  final bool freeShipping; // For free shipping
  final bool hasWarranty; // For warranty
  final String? warrantyPeriod; // Warranty duration

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.category,
    this.discountPercentage,
    this.freeShipping = false,
    this.hasWarranty = false,
    this.warrantyPeriod,
  });

  // Calculate discounted price
  double get discountedPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  // Check if product is on flash sale
  bool get isOnFlashSale => discountPercentage != null && discountPercentage! > 0;

  // Sample data
  static List<Product> sampleProducts = [
    Product(
      id: '1',
      name: 'iPhone 15 Pro',
      description: 'Smartphone terbaru dengan kamera canggih dan performa tinggi',
      price: 18999000,
      imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=300&fit=crop',
      stock: 5,
      category: 'Elektronik',
      discountPercentage: 15, // Flash sale
      freeShipping: true,
      hasWarranty: true,
      warrantyPeriod: '1 tahun',
    ),
    Product(
      id: '2',
      name: 'MacBook Air M3',
      description: 'Laptop ultrabook dengan chip M3 untuk produktivitas maksimal',
      price: 24999000,
      imageUrl: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400&h=300&fit=crop',
      stock: 3,
      category: 'Elektronik',
      discountPercentage: 10, // Flash sale
      freeShipping: true,
      hasWarranty: true,
      warrantyPeriod: '2 tahun',
    ),
    Product(
      id: '3',
      name: 'Nike Air Max',
      description: 'Sepatu olahraga dengan teknologi cushioning terdepan',
      price: 1299000,
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=300&fit=crop',
      stock: 15,
      category: 'Fashion',
      freeShipping: true,
      hasWarranty: true,
      warrantyPeriod: '6 bulan',
    ),
    Product(
      id: '4',
      name: 'Samsung 4K TV 55"',
      description: 'Televisi 4K UHD dengan Smart TV dan HDR',
      price: 8999000,
      imageUrl: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400&h=300&fit=crop',
      stock: 8,
      category: 'Elektronik',
      discountPercentage: 20, // Flash sale
      freeShipping: true,
      hasWarranty: true,
      warrantyPeriod: '2 tahun',
    ),
    Product(
      id: '5',
      name: 'Adidas Ultraboost',
      description: 'Sepatu running dengan Boost technology untuk kenyamanan maksimal',
      price: 2199000,
      imageUrl: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&h=300&fit=crop',
      stock: 12,
      category: 'Fashion',
    ),
    Product(
      id: '6',
      name: 'Blender Philips',
      description: 'Blender high-speed untuk membuat smoothie dan jus',
      price: 899000,
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
      stock: 20,
      category: 'Rumah Tangga',
    ),
    Product(
      id: '7',
      name: 'Dumbbell Set 20kg',
      description: 'Set dumbbell adjustable untuk latihan kekuatan di rumah',
      price: 1499000,
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      stock: 6,
      category: 'Olahraga',
    ),
    Product(
      id: '8',
      name: 'Vitamin C 1000mg',
      description: 'Suplemen vitamin C untuk meningkatkan daya tahan tubuh',
      price: 125000,
      imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=400&h=300&fit=crop',
      stock: 50,
      category: 'Kesehatan',
    ),
  ];

  static List<String> get categories => [
    'Semua',
    'Elektronik',
    'Fashion',
    'Rumah Tangga',
    'Olahraga',
    'Kesehatan',
  ];
}