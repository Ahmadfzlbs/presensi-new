import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.nisC.text = user["nis"];
    controller.namaC.text = user["nama"];
    controller.emailC.text = user["email"];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.lightBlue[400],
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 18, fontFamily: "PoppinLight", color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            readOnly: true,
            controller: controller.nisC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                label: Text("NIS"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 15),
          TextFormField(
            readOnly: true,
            controller: controller.emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              label: Text("Email"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
            readOnly: true,
            controller: controller.namaC,
            decoration: InputDecoration(
              label: Text("Nama"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Foto Profil",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[400], fontFamily: 'PoppinLight'),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(builder: (c) {
                if (c.image != null) {
                  return ClipOval(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Image.file(
                        File(c.image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  if (user["profile"] != null) {
                    return Column(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              user["profile"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(onPressed: () async {
                          await controller.deleteProfile(user["uid"]);
                        }, child: Text("Hapus foto",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[400], fontFamily: 'PoppinLight'),
                        ))
                      ],
                    );
                  } else {
                    return ClipOval(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          "https://forum.truckersmp.com/uploads/monthly_2020_03/imported-photo-202022.thumb.png.81943bfe1be32614be2b23043e189bd5.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                }
              }),
              TextButton(onPressed: () async {
                await controller.pickImage();
              }, child: Text("Pilih foto",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[400], fontFamily: 'PoppinLight'),
              ))
            ],
          ),
          SizedBox(height: 30),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await controller.updateProfile(user["uid"]);
                  },
                  icon: Icon(Icons.save),
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary:
                      Colors.lightBlue[300],
                      shape:
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              20))),
                  label: Text(controller.isLoading.isFalse
                      ? 'Simpan Perubahan'
                      : "Tunggu...",
                    style: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
