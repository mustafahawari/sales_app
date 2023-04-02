class ProductModel {
  String? id;
  final String name;
  final String price;
  final String? description;
  final DateTime? created;
  final DateTime? updated;
  ProductModel(
      {this.id,
      required this.name,
      required this.price,
      this.description,
      this.created,
      this.updated});

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      created: json['created'],
      updated: json['updated']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'created': created,
      'updated': updated
    };
  }
}
