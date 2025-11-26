class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  // Sample data
  static List<Product> sampleProducts = [
    Product(
      id: '1',
      name: 'Nasi Goreng',
      description: 'Nasi goreng spesial dengan telur dan ayam',
      price: 25000,
      imageUrl: 'https://via.placeholder.com/150',
      stock: 10,
    ),
    Product(
      id: '2',
      name: 'Ayam Bakar',
      description: 'Ayam bakar dengan bumbu rempah',
      price: 35000,
      imageUrl: 'https://via.placeholder.com/150',
      stock: 8,
    ),
    Product(
      id: '3',
      name: 'Es Teh Manis',
      description: 'Teh manis dingin segar',
      price: 5000,
      imageUrl: 'https://via.placeholder.com/150',
      stock: 20,
    ),
    Product(
      id: '4',
      name: 'Bakso',
      description: 'Bakso daging sapi dengan mie',
      price: 15000,
      imageUrl: 'https://via.placeholder.com/150',
      stock: 15,
    ),
  ];
}