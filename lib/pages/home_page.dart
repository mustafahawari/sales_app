import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:sales_transaction_app/controller/product_controller.dart';
import 'package:sales_transaction_app/pages/customer/customers_page.dart';
import 'package:sales_transaction_app/pages/product_page/product_page.dart';
import 'package:sales_transaction_app/pages/sales_page/sales_page.dart';

import '../controller/customer_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Get.find<CustomerControler>().getCustomer();
    Get.find<ProductController>().getProducts();
  }

  List<Map<String, dynamic>> dItems = [
    {
      "name": "Customers",
      "image": "assets/customer.png",
    },
    {"name": "Products", "image": "assets/product.png"},
    {"name": "Sales", "image": "assets/sales.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text("Sales App"),
      ),
      body: GridView.builder(
        itemCount: dItems.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Get.to(() => const CustomersPage());
              } else if (index == 1) {
                Get.to(() => const ProductPage());
              } else if (index == 2) {
                Get.to(() => SalesPage());
              }
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(dItems[index]['image']),
                  Text(
                    dItems[index]['name'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
