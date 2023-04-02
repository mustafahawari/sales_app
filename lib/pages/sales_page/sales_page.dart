import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/controller/customer_controller.dart';
import 'package:sales_transaction_app/models/customer_model.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final controller = Get.find<CustomerControler>();
  CustomerModel? selectedCustomer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: DropdownButton<CustomerModel>(
                  value: selectedCustomer,
                  hint: const Text("Select customer to view sales transactions"),
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
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
