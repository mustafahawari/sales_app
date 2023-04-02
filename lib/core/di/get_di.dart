import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/instance_manager.dart';
import 'package:sales_transaction_app/controller/customer_controller.dart';
import 'package:sales_transaction_app/controller/product_controller.dart';
import 'package:sales_transaction_app/data_source/customer_data_source.dart';
import 'package:sales_transaction_app/data_source/product_data_source.dart';

import '../../database/database_connection.dart';

class ServiceLocator {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
    // debugPrint("ENV: ${env.map.keys}");
    final db = DatabaseConnection();

    //data sources
    Get.lazyPut<CustomerDataSource>(() => CustomerDataSourceImpl(db));
    Get.lazyPut<ProductDataSource>(() => ProductDataSourceImpl(db));

    //controllers
    Get.lazyPut<CustomerControler>(() => CustomerControler(Get.find()));
    Get.lazyPut<ProductController>(() => ProductController(Get.find()));
  }
}
