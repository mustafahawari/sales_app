import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/controller/product_controller.dart';
import 'package:sales_transaction_app/controller/sales_controller.dart';
import 'package:sales_transaction_app/core/utils/custom_snackbar.dart';
import 'package:sales_transaction_app/models/product_model.dart';
import 'package:sales_transaction_app/models/sales_model.dart';

import '../../../controller/customer_controller.dart';
import '../../../models/customer_model.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final customerController = Get.find<CustomerControler>();
  final salesController = Get.find<SalesController>();
  final quantityController = TextEditingController();
  CustomerModel? selectedCustomer;
  ProductModel? selectedProduct;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<CustomerModel>(
                  value: selectedCustomer,
                  underline: const SizedBox(),
                  hint: const Text("Select customer"),
                  isExpanded: true,
                  items: customerController.customers.map((cm) {
                    return DropdownMenuItem<CustomerModel>(
                      value: cm,
                      child: Text(cm.firstName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCustomer = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GetX<ProductController>(builder: (productController) {
                return Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<ProductModel>(
                    underline: const SizedBox(),
                    value: selectedProduct,
                    hint: const Text("Select product"),
                    isExpanded: true,
                    items: productController.products.map((pm) {
                      return DropdownMenuItem<ProductModel>(
                        value: pm,
                        child: Text(pm.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                      });
                    },
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Quantity*",
                  labelText: "Quantity*",
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
                    if (selectedCustomer == null) {
                      showCustomSnackBar("Please select customer", isError: true);
                    } else if (selectedProduct == null) {
                      showCustomSnackBar("Please select product", isError: true);
                    } else if (quantityController.text.isEmpty) {
                      showCustomSnackBar("Please enter quantity", isError: true);
                    } else {
                      SalesModel salesModel = SalesModel(
                        customerId: selectedCustomer!.id!,
                        customerName:
                            "${selectedCustomer!.firstName} ${selectedCustomer!.lastName}",
                        productId: selectedProduct!.id!,
                        productRate: selectedProduct!.price,
                        quantity: quantityController.text,
                        productName: selectedProduct!.name,
                      );
                      log(salesModel.customerId.length.toString());
                      log(salesModel.customerName.length.toString());
                      log(salesModel.productId.length.toString());
                      log(salesModel.productRate.length.toString());
                      print("${salesModel.productRate} This much");
                      log(salesModel.quantity.length.toString());
                      log(salesModel.productName.length.toString());
                      
                      await Get.find<SalesController>()
                          .addSaleTransaction(salesModel);
                      final status = Get.find<SalesController>().status;

                      if (status.value == SalesStatus.loaded) {
                        showCustomSnackBar("Added Successfully");
                        Navigator.pop(context);
                      } else if (status.value == SalesStatus.error) {
                        final em = Get.find<SalesController>().errorMessage;
                        showCustomSnackBar(em);
                      }
                    }
                    // if (nameController.text.isNotEmpty &&
                    //     priceController.text.isNotEmpty) {
                    //   ProductModel productModel = ProductModel(
                    //       id: editProduct?.id,
                    //       name: nameController.text,
                    //       price: priceController.text,
                    //       description: descriptionController.text,
                    //       );
                    //   if (editProduct == null) {
                    //     controller.addProduct(productModel).then((value) {
                    //       if (controller.status.value ==
                    //           ProductStatus.loaded) {
                    //         showCustomSnackBar("Added Successfully");
                    //         Navigator.pop(context);
                    //       }
                    //     });
                    //   } else {
                    //     controller.updateProduct(productModel).then((value) {
                    //       if (controller.status.value ==
                    //           ProductStatus.loaded) {
                    //         showCustomSnackBar("Updated Successfully");
                    //         Navigator.pop(context);
                    //       }
                    //     });
                    //   }
                    // } else {
                    //   showCustomSnackBar("Please fill up required fields !");

                    // }
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
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
          salesController.status.value == SalesStatus.loading ? const Center(child: CircularProgressIndicator(),): const SizedBox()
        ],
      );
    });
  }
}
