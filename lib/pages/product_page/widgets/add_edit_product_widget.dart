import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/controller/product_controller.dart';
import 'package:sales_transaction_app/core/utils/custom_snackbar.dart';
import 'package:sales_transaction_app/models/product_model.dart';

class AddEditProduct extends StatelessWidget {
  final ProductModel? editProduct;
  AddEditProduct({super.key, this.editProduct});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final controller = Get.find<ProductController>();
  void setUpdateInitialValue() {
    if (editProduct != null) {
      nameController.text = editProduct!.name;
      priceController.text =  editProduct!.price;
      descriptionController.text = editProduct!.description ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    setUpdateInitialValue();
    return Obx(() {
      // if (controller.status.value == ProductStatus.error) {
      //   Get.snackbar("Error", controller.errorMessage);
      // }

      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Product name*",
                  labelText: "Product name*",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Product price*",
                  labelText: "Product price*",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Product description",
                  labelText: "Product description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        priceController.text.isNotEmpty) {
                      ProductModel productModel = ProductModel(
                          id: editProduct?.id,
                          name: nameController.text,
                          price: priceController.text,
                          description: descriptionController.text,
                          );
                      if (editProduct == null) {
                        controller.addProduct(productModel).then((value) {
                          if (controller.status.value ==
                              ProductStatus.loaded) {
                            showCustomSnackBar("Added Successfully");
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        controller.updateProduct(productModel).then((value) {
                          if (controller.status.value ==
                              ProductStatus.loaded) {
                            showCustomSnackBar("Updated Successfully");
                            Navigator.pop(context);
                          }
                        });
                      }
                    } else {
                      showCustomSnackBar("Please fill up required fields !");
                      
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onPrimary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                  ),
                  child: Text(editProduct == null ? "Submit" : "Update"),
                ),
              ),
            ],
          ),
          controller.status.value == ProductStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox()
        ],
      );
    });
  }
}
