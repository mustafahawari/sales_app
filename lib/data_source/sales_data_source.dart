import 'package:flutter/foundation.dart';
import 'package:sales_transaction_app/database/database_connection.dart';
import 'package:sales_transaction_app/models/sales_model.dart';
import 'package:uuid/uuid.dart';

abstract class SalesDataSource {
  Future<void> addSaleTransaction(SalesModel salesModel);
  Future<List<SalesModel>> getSaleTransactionByCustomerId(
      SalesModel salesModel);
  Future<void> deleteTransaction(SalesModel salesModel);
}

class SalesDataSourceImpl implements SalesDataSource {
  final DatabaseConnection database;
  SalesDataSourceImpl(this.database);
  @override
  Future<void> addSaleTransaction(SalesModel salesModel) async {
    try {
      await database.connect();
      var uuid = const Uuid();
      salesModel.id = uuid.v4();
      final result = await database.db.query(
        '''
      INSERT INTO sales_transaction (id, customer_id, customer_name, product_id, product_rate, product_name, quantity)
      VALUES (@id, @customer_id, @customer_name, @product_id, @product_rate, @product_name, @quantity)
      RETURNING *
      ''',
        substitutionValues: salesModel.toMap(),
      );
      if (result.affectedRowCount == 0) {
        throw Exception('Failed to add transaction');
      }
      final salesTransactionMap = result.first.toColumnMap();
      debugPrint(salesTransactionMap.toString());
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<List<SalesModel>> getSaleTransactionByCustomerId(
      SalesModel salesModel) async {
    try {
      await database.connect();
      final result = await database.db.query('''
        SELECT * from sales_transaction
        WHERE customer_id = @customer_id
        ''', substitutionValues: {'customer_id': salesModel.customerId});
      final List<SalesModel> sm = result
          .map((e) => e.toColumnMap())
          .map((e) => SalesModel.fromMap(e))
          .toList();
      return sm;
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<void> deleteTransaction(SalesModel salesModel) async {
    try {
      await database.connect();
      await database.db.query('''
        DELETE FROM sales_transaction
        WHERE id = @id
        ''', substitutionValues: {'id': salesModel.id});
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }
}
