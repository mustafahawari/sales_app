import 'package:get/get.dart';
import 'package:sales_transaction_app/data_source/product_data_source.dart';
import 'package:sales_transaction_app/models/product_model.dart';

import '../core/utils/custom_snackbar.dart';

class ProductController extends GetxController {
  Rx<ProductStatus> status = ProductStatus.initial.obs;
  String errorMessage = "";
  RxList<ProductModel> products = <ProductModel>[].obs;
  ProductDataSource productDataSource;
  ProductController(this.productDataSource);

  Future<void> addProduct(ProductModel productModel) async {
    try {
      status.value = ProductStatus.loading;
      await productDataSource.addProduct(productModel);
      getProducts();
      status.value = ProductStatus.loaded;
    } catch (e) {
      status.value = ProductStatus.error;
      errorMessage = e.toString();
    }
  }

  Future<void> getProducts() async {
    try {
      status.value = ProductStatus.loading;
      final data = await productDataSource.getAllProducts();

      products.value = data;
      status.value = ProductStatus.loaded;
    } catch (e) {
      status.value = ProductStatus.error;
      errorMessage = e.toString();
    }
  }

  Future<void> updateProduct(ProductModel productModel) async {
    try {
      status.value = ProductStatus.loading;
      await productDataSource.updateProduct(productModel);
      getProducts();
      status.value = ProductStatus.loaded;
    } catch (e) {
      status.value = ProductStatus.error;
      errorMessage = e.toString();
    }
  }

  Future<void> deleteProduct(ProductModel customerModel) async {
    try {
      status.value = ProductStatus.loading;
      await productDataSource.deleteProduct(customerModel);
      products.removeWhere((element) => element.id == customerModel.id);
      status.value = ProductStatus.loaded;
      showCustomSnackBar("Deleted");
    } catch (e) {
      status.value = ProductStatus.error;
      errorMessage = e.toString();
      showCustomSnackBar(errorMessage);
    }
  }
}

enum ProductStatus {
  initial,
  loading,
  loaded,
  error,
}
