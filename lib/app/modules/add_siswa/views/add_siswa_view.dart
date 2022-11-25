import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_siswa_controller.dart';

class AddSiswaView extends GetView<AddSiswaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Siswa'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: controller.nisC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: Text("NIS"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: controller.emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              label: Text("Email"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: controller.namaC,
            decoration: InputDecoration(
                label: Text("Nama"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: controller.kelasC,
            decoration: InputDecoration(
              label: Text("Kelas"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
                onPressed: () async {
                  if(controller.isLoading.isFalse){
                    await controller.addSiswa();
                  }
                },
                child:Text(controller.isLoading.isFalse ? 'Tambah Siswa' : "Tunggu..."),
            ),
          )
        ],
      ),
    );
  }
}
