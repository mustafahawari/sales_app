import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/pages/home_page.dart';

import 'core/di/get_di.dart';

Future<void> main() async {
  await ServiceLocator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sales Transaction App',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true
      ),
      home: const HomePage()
    );
  }
}



