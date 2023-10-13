class Product {
   String barcode;
    int? number;
  String? name;

  Product({
    required this.barcode,
     this.number,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'number': number,
      'name': name,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barcode: map['barcode'] as String,
      number: map['number'] as int,
      name: map['name'] as String?,
    );
  }
}
