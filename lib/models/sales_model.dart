class SalesModel {
  String? id;
  final String customerId;
  final String productId;
  final String quantity;
  final String customerName;
  final String productRate;
  final String productName;
  final DateTime? created;
  final DateTime? updated;
  SalesModel({
    this.id,
    required this.customerId,
    required this.customerName,
    required this.productId,
    required this.productRate,
    required this.quantity,
    required this.productName,
    this.created,
    this.updated,
  });
  factory SalesModel.fromMap(Map<String, dynamic> data) {
    return SalesModel(
      id: data['id'],
      customerId: data['customer_id'],
      customerName: data['customer_name'],
      productId: data['product_id'],
      productRate: data['product_rate'],
      productName: data['product_name'],
      quantity: data['quantity'],
      created: data['created'],
      updated: data['updated'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': id,
      'customer_name': id,
      'product_id': id,
      'product_rate': id,
      'product_name': id,
      'quantity': id,
      'created': id,
      'updated': id,
    };
  }
}
