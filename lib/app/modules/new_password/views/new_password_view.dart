import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Password'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.newPassC,
              autocorrect: false,
              decoration: InputDecoration(
                  labelText: 'Kata sandi baru',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  controller.newPassword();
                },
                child: Text('Lanjutkan'))
          ],
        ));
  }
}
