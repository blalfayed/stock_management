// Product Model
class Product {
  final int? id;
  final String name;
  final int quantity;
  final double price;
  final String location;
  final String expiryDate;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.location,
    required this.expiryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'location': location,
      'expiryDate': expiryDate,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      location: map['location'],
      expiryDate: map['expiryDate'],
    );
  }
}
