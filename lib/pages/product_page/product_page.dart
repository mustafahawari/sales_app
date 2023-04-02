import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/controller/product_controller.dart';
import 'package:sales_transaction_app/pages/common_widgets/core_dialog.dart';
import 'package:sales_transaction_app/pages/product_page/widgets/add_edit_product_widget.dart';


class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCoreDialog(
            context,
            title: "Add Product",
            child: AddEditProduct(),
          );
        },
        label: const Text("Add"),
        icon: const Icon(Icons.add),
      ),
      body: GetX<ProductController>(
        builder: (controller) {
          debugPrint(controller.products.length.toString());
          return Stack(
            children: [
              ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (DismissDirection direction) async {
                      if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart) {
                        await controller.deleteProduct(controller.products[index]);
                       
                      }
                    },
                    child: ListTile(
                      
                      onTap: () {
                        showCoreDialog(
                          context,
                          child: AddEditProduct(
                            editProduct: controller.products[index],
                          ),
                          title: "Edit Customer Details",
                        );
                      },
                      trailing: Text("Rs. ${controller.products[index].price}"),
                      title: Text(
                        controller.products[index].name,
                      ),
                    ),
                  );
                },
              ),
              controller.status.value == ProductStatus.loading
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
