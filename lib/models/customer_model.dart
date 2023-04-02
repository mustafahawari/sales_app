class CustomerModel {
  String? id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? address;
  final String? email;
  final DateTime? created;
  final DateTime? updated;

  CustomerModel({
    this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.address,
    this.email,
    this.created,
    this.updated,
  });
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
      created: json['created'],
      updated: json['updated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
      'email': email,
      'address': address,
      'created': created,
      'updated': updated,
    };
  }
}
