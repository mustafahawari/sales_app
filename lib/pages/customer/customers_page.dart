import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/pages/common_widgets/core_dialog.dart';
import 'package:sales_transaction_app/pages/customer/widgets/add_edit_cutomer_widget.dart';

import '../../controller/customer_controller.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCoreDialog(
            context,
            title: "Add Cutomer",
            child: AddEditCustomer(),
          );
        },
        label: const Text("Add"),
        icon: const Icon(Icons.add),
      ),
      body: GetX<CustomerControler>(
        builder: (controller) {
          debugPrint(controller.customers.length.toString());
          return Stack(
            children: [
              ListView.builder(
                itemCount: controller.customers.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (DismissDirection direction) async {
                      if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart) {
                        await controller.deleteCustomer(controller.customers[index]);
                       
                      }
                    },
                    child: ListTile(
                      selectedColor: Colors.black,
                      selected: true,
                      onTap: () {
                        showCoreDialog(
                          context,
                          child: AddEditCustomer(
                            editCustomer: controller.customers[index],
                          ),
                          title: "Edit Customer Details",
                        );
                      },
                      title: Text(
                        "${controller.customers[index].firstName} ${controller.customers[index].lastName}",
                      ),
                    ),
                  );
                },
              ),
              controller.status.value == CustomerStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }
}
