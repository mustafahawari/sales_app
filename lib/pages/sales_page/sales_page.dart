import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/controller/customer_controller.dart';
import 'package:sales_transaction_app/controller/sales_controller.dart';
import 'package:sales_transaction_app/models/customer_model.dart';
import 'package:sales_transaction_app/pages/sales_page/widgets.dart/add_transactions.dart';

import '../common_widgets/core_dialog.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final controller = Get.find<CustomerControler>();
  CustomerModel? selectedCustomer;
  final ScrollController sc = ScrollController();
  String calculateTotal(String rate, String quantity) {
    double parsedRate = double.parse(rate);
    double parsedQuantity = double.parse(quantity);
    double total = parsedRate * parsedQuantity;
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales"),
        leading: IconButton(
            onPressed: () {
              Get.find<SalesController>().salesTransactionOfCustomer.value = [];
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCoreDialog(context,
              title: "Add Sale Transaction", child: const AddTransaction());
        },
        label: const Text("Add"),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: sc,
              child: Column(
                children: [
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      child: DropdownButton<CustomerModel>(
                        value: selectedCustomer,
                        hint: const Text(
                            "Select customer to view sales transactions"),
                        isExpanded: true,
                        items: controller.customers.map((cm) {
                          return DropdownMenuItem<CustomerModel>(
                            value: cm,
                            child: Text(cm.firstName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCustomer = value;
                          });
                          Get.find<SalesController>()
                              .getAllTransactionsofCustomer(
                                  selectedCustomer!.id!);
                        },
                      ),
                    );
                  }),
                  GetX<SalesController>(
                    builder: (controller) {
                      return controller.salesTransactionOfCustomer.isEmpty
                          ? const Center(
                              child: Text("No Transactions"),
                            )
                          : SingleChildScrollView(
                              controller: sc,
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      Expanded(
                                        child: Text(
                                          "Product Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Rate",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Quantity",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Total(in Rs)",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                      controller: sc,
                                      shrinkWrap: true,
                                      itemCount: controller
                                          .salesTransactionOfCustomer.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Dismissible(
                                            key: UniqueKey(),
                                            onDismissed: (DismissDirection
                                                direction) async {
                                              if (direction ==
                                                      DismissDirection
                                                          .startToEnd ||
                                                  direction ==
                                                      DismissDirection
                                                          .endToStart) {
                                                await controller
                                                    .deleteTransaction(controller
                                                            .salesTransactionOfCustomer[
                                                        index]);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(controller
                                                      .salesTransactionOfCustomer[
                                                          index]
                                                      .productName),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                      .salesTransactionOfCustomer[
                                                          index]
                                                      .productRate),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                      .salesTransactionOfCustomer[
                                                          index]
                                                      .quantity),
                                                ),
                                                Expanded(
                                                  child: Text(calculateTotal(
                                                      controller
                                                          .salesTransactionOfCustomer[
                                                              index]
                                                          .productRate,
                                                      controller
                                                          .salesTransactionOfCustomer[
                                                              index]
                                                          .quantity)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                ],
                              ),
                            );
                    },
                  )
                ],
              ),
            ),
            Obx(() {
              return Get.find<SalesController>().status.value ==
                      SalesStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox();
            })
          ],
        ),
      ),
    );
  }
}
