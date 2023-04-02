import 'package:flutter/material.dart';
import 'package:sales_transaction_app/database/database_connection.dart';
import 'package:uuid/uuid.dart';

import '../models/customer_model.dart';

abstract class CustomerDataSource {
  Future<void> addCustomer(CustomerModel customer);
  Future<List<CustomerModel>> getAllCustomers();
  Future<void> updateCustomer(CustomerModel customerModel);
  Future<void> deleteCustomer(CustomerModel customerModel);
}

class CustomerDataSourceImpl implements CustomerDataSource {
  DatabaseConnection database;
  CustomerDataSourceImpl(this.database);
  @override
  Future<void> addCustomer(CustomerModel customer) async {
    try {
      await database.connect();
      var uuid = const Uuid();
      customer.id = uuid.v4();
      final result = await database.db.query(
        '''
      INSERT INTO customer (id, firstname, lastname, phone, address, email)
      VALUES (@id, @firstname, @lastname, @phone, @address, @email)
      RETURNING *
      ''',
        substitutionValues: customer.toMap(),
      );
      if (result.affectedRowCount == 0) {
        throw Exception('Failed to add customer');
      }
      final customerMap = result.first.toColumnMap();
      debugPrint(customerMap.toString());
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      await database.connect();
      final result = await database.db.query('''
        SELECT * from CUSTOMER
        ''');
      final List<CustomerModel> cm = result
          .map((e) => e.toColumnMap())
          .map((e) => CustomerModel.fromJson(e))
          .toList();
      return cm;
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<void> updateCustomer(CustomerModel customerModel) async {
    try {
      await database.connect();
      debugPrint(customerModel.toMap().toString());
      final result = await database.db.query('''
        UPDATE customer
        SET firstname = @firstname,
            lastname = @lastname,
            email = @email,
            phone = @phone,
            address = @address,
            updated = current_timestamp
        WHERE id = @id
        RETURNING *
        ''', substitutionValues: customerModel.toMap());
      if (result.isEmpty) {
        throw Exception('Customer not found');
      }
      debugPrint(result.first.toColumnMap().toString());
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<void> deleteCustomer(CustomerModel customerModel) async {
    try {
      await database.connect();
      await database.db.query('''
        DELETE FROM customer
        WHERE id = @id
        ''', substitutionValues: {'id': customerModel.id});
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }
}
