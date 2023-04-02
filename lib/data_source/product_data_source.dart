
import 'package:flutter/foundation.dart';
import 'package:sales_transaction_app/models/product_model.dart';
import 'package:uuid/uuid.dart';

import '../database/database_connection.dart';

abstract class ProductDataSource {
  Future<void> addProduct(ProductModel product);
  Future<List<ProductModel>> getAllProducts();
  Future<void> updateProduct(ProductModel productModel);
  Future<void> deleteProduct(ProductModel productModel); 
}

class ProductDataSourceImpl implements ProductDataSource {
  DatabaseConnection database;
  ProductDataSourceImpl(this.database);
  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      await database.connect();
      var uuid = const Uuid();
      product.id = uuid.v4();
      final result = await database.db.query(
      '''
      INSERT INTO product (id, name, price, description)
      VALUES (@id, @name, @price, @description)
      RETURNING *
      ''',
        substitutionValues: product.toMap(),
      );
      if (result.affectedRowCount == 0) {
        throw Exception('Failed to add product');
      }
      final productMap = result.first.toColumnMap();
      debugPrint(productMap.toString());
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<void> deleteProduct(ProductModel productModel) async {
    try {
      await database.connect();
      await database.db.query('''
        DELETE FROM product
        WHERE id = @id
        ''', substitutionValues: {'id': productModel.id});
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      await database.connect();
      final result = await database.db.query('''
        SELECT * from PRODUCT
        ''');
      final List<ProductModel> pm = result
          .map((e) => e.toColumnMap())
          .map((e) => ProductModel.fromMap(e))
          .toList();
      return pm;
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }

  @override
  Future<void> updateProduct(ProductModel productModel) async {
    try {
      await database.connect();
      debugPrint(productModel.toMap().toString());
      final result = await database.db.query('''
        UPDATE product
        SET name = @name,
            price = @price,
            description = @description,
            updated = current_timestamp
        WHERE id = @id
        RETURNING *
        ''', substitutionValues: productModel.toMap());
      if (result.isEmpty) {
        throw Exception('Product not found');
      }
      debugPrint(result.first.toColumnMap().toString());
    } catch (e) {
      rethrow;
    } finally {
      await database.close();
    }
  }
  
}