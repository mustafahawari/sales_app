import 'dart:developer';

import 'package:get/get.dart';
import 'package:sales_transaction_app/data_source/sales_data_source.dart';
import 'package:sales_transaction_app/models/sales_model.dart';

import '../core/utils/custom_snackbar.dart';

class SalesController extends GetxController {
  Rx<SalesStatus> status = SalesStatus.initial.obs;
  String errorMessage = "";
  RxList<SalesModel> salesTransactionOfCustomer = <SalesModel>[].obs;
  SalesDataSource salesDataSource;
  SalesController(this.salesDataSource);


  Future<void> getAllTransactionsofCustomer(String customerId) async {
    try {
      status.value = SalesStatus.loading;
      final data = await salesDataSource.getSaleTransactionByCustomerId(customerId);
      log(data.toString());
      salesTransactionOfCustomer.value = data;
      status.value = SalesStatus.loaded;
    } catch (e) {
      status.value = SalesStatus.error;
      errorMessage = e.toString();
    }
  }

  Future<void> addSaleTransaction(SalesModel salesModel) async {
    try {
      status.value = SalesStatus.loading;
      await salesDataSource.addSaleTransaction(salesModel);
      status.value = SalesStatus.loaded;
    } catch (e) {
      status.value = SalesStatus.error;
      errorMessage = e.toString();
    }
  }

    Future<void> deleteTransaction(SalesModel salesModel) async {
    try {
      status.value = SalesStatus.loading;
      await salesDataSource.deleteTransaction(salesModel);
      salesTransactionOfCustomer.removeWhere((element) => element.id == salesModel.id);
      status.value = SalesStatus.loaded;
      showCustomSnackBar("Deleted");
    } catch (e) {
      status.value = SalesStatus.error;
      errorMessage = e.toString();
      showCustomSnackBar(errorMessage, isError: true);
    }
  }
}
enum SalesStatus {
  initial,
  loading,
  loaded,
  error
}