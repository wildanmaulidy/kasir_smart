class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.category,
  });

  // Sample data
  static List<Product> sampleProducts = [
    Product(
      id: '1',
      name: 'Nasi Goreng',
      description: 'Nasi goreng spesial dengan telur dan ayam',
      price: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=300&fit=crop',
      stock: 10,
      category: 'Makanan Utama',
    ),
    Product(
      id: '2',
      name: 'Ayam Bakar',
      description: 'Ayam bakar dengan bumbu rempah',
      price: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400&h=300&fit=crop',
      stock: 8,
      category: 'Makanan Utama',
    ),
    Product(
      id: '3',
      name: 'Es Teh Manis',
      description: 'Teh manis dingin segar',
      price: 5000,
      imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&h=300&fit=crop',
      stock: 20,
      category: 'Minuman',
    ),
    Product(
      id: '4',
      name: 'Bakso',
      description: 'Bakso daging sapi dengan mie',
      price: 15000,
      imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400&h=300&fit=crop',
      stock: 15,
      category: 'Makanan Utama',
    ),
    Product(
      id: '5',
      name: 'Sate Ayam',
      description: 'Sate ayam dengan bumbu kacang',
      price: 20000,
      imageUrl: 'https://images.unsplash.com/photo-1529563021893-cc83c992d75d?w=400&h=300&fit=crop',
      stock: 12,
      category: 'Makanan Utama',
    ),
    Product(
      id: '6',
      name: 'Rendang',
      description: 'Rendang daging sapi khas Padang',
      price: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
      stock: 6,
      category: 'Makanan Utama',
    ),
    Product(
      id: '7',
      name: 'Gado-Gado',
      description: 'Sayur segar dengan bumbu kacang',
      price: 18000,
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400&h=300&fit=crop',
      stock: 10,
      category: 'Makanan Ringan',
    ),
    Product(
      id: '8',
      name: 'Jus Jeruk',
      description: 'Jus jeruk segar tanpa gula',
      price: 8000,
      imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=300&fit=crop',
      stock: 25,
      category: 'Minuman',
    ),
  ];

  static List<String> get categories => [
    'Semua',
    'Makanan Utama',
    'Makanan Ringan',
    'Minuman',
  ];
}