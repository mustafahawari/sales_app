import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_transaction_app/controller/customer_controller.dart';
import 'package:sales_transaction_app/core/utils/custom_snackbar.dart';
import 'package:sales_transaction_app/models/customer_model.dart';

class AddEditCustomer extends StatelessWidget {
  final CustomerModel? editCustomer;
  AddEditCustomer({super.key, this.editCustomer});
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final controller = Get.find<CustomerControler>();
  void setUpdateInitialValue() {
    if (editCustomer != null) {
      firstNameController.text = editCustomer!.firstName;
      lastNameNameController.text = editCustomer!.lastName;
      emailController.text = editCustomer!.email ?? "";
      addressController.text = editCustomer!.address ?? "";
      phoneNumberController.text = editCustomer!.phone ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    setUpdateInitialValue();
    return Obx(() {
      // if (controller.status.value == CustomerStatus.error) {
      //   Get.snackbar("Error", controller.errorMessage);
      // }

      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: "First name*",
                  labelText: "First Name*",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: lastNameNameController,
                decoration: const InputDecoration(
                  hintText: "Last name*",
                  labelText: "Last Name*",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: "Address",
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Phone number",
                  labelText: "Phone number",
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
                    if (firstNameController.text.isNotEmpty &&
                        lastNameNameController.text.isNotEmpty) {
                      CustomerModel customerModel = CustomerModel(
                          id: editCustomer?.id,
                          firstName: firstNameController.text,
                          lastName: lastNameNameController.text,
                          email: emailController.text,
                          phone: phoneNumberController.text,
                          address: addressController.text);
                      if (editCustomer == null) {
                        controller.addCustomer(customerModel).then((value) {
                          if (controller.status.value ==
                              CustomerStatus.loaded) {
                            showCustomSnackBar("Added Successfully");
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        controller.updateCustomer(customerModel).then((value) {
                          if (controller.status.value ==
                              CustomerStatus.loaded) {
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
                  child: Text(editCustomer == null ? "Submit" : "Update"),
                ),
              ),
            ],
          ),
          controller.status.value == CustomerStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox()
        ],
      );
    });
  }
}
