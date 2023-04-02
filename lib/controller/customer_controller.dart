import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sales_transaction_app/core/utils/custom_snackbar.dart';
import 'package:sales_transaction_app/data_source/customer_data_source.dart';
import 'package:sales_transaction_app/models/customer_model.dart';

class CustomerControler extends GetxController {
  Rx<CustomerStatus> status = CustomerStatus.initial.obs;
  String errorMessage = "";
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  CustomerDataSource customerDataSource;
  CustomerControler(this.customerDataSource);
  Future<void> addCustomer(CustomerModel customerModel) async {
    try {
      status.value = CustomerStatus.loading;
      await customerDataSource.addCustomer(customerModel);
      getCustomer();
      status.value = CustomerStatus.loaded;
    } catch (e) {
      status.value = CustomerStatus.error;
      errorMessage = e.toString();
    }
  }

  Future<void> getCustomer() async {
    try {
      status.value = CustomerStatus.loading;
      final data = await customerDataSource.getAllCustomers();

      customers.value = data;
      status.value = CustomerStatus.loaded;
    } catch (e) {
      status.value = CustomerStatus.error;
      errorMessage = e.toString();
    }
  }

  Future<void> updateCustomer(CustomerModel customerModel) async {
    try {
      status.value = CustomerStatus.loading;
      await customerDataSource.updateCustomer(customerModel);
      getCustomer();
      status.value = CustomerStatus.loaded;
    } catch (e) {
      status.value = CustomerStatus.error;
      errorMessage = e.toString();
    }
  }

  Future<void> deleteCustomer(CustomerModel customerModel) async {
    try {
      status.value = CustomerStatus.loading;
      await customerDataSource.deleteCustomer(customerModel);
      customers.removeWhere((element) => element.id == customerModel.id);
      status.value = CustomerStatus.loaded;
      showCustomSnackBar("Deleted");
    } catch (e) {
      status.value = CustomerStatus.error;
      errorMessage = e.toString();
      showCustomSnackBar(errorMessage);
    }
  }
}

enum CustomerStatus {
  initial,
  loading,
  loaded,
  error,
}
