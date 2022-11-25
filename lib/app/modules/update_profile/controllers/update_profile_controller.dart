import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nisC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController namaC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  Future<void> pickImage() async {
    WidgetsFlutterBinding.ensureInitialized();
    var storage = await Permission.storage;
    if (await storage.request().isLimited) {
      openAppSettings();
    } else if (await storage.request().isDenied) {
      openAppSettings();
    } else if (await storage.request().isPermanentlyDenied) {
      openAppSettings();
    } else if (await storage.request().isRestricted) {
      openAppSettings();
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
      } else {
        print(image);
      }
      update();
    }
  }

  Future<void> updateProfile(String uid) async {
    isLoading.value = true;
    if (nisC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        namaC.text.isNotEmpty) {
      try {
        Map<String, dynamic> data = {"nama": namaC.text};
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split(".").last;

          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({"profile": urlImage});
        }
        await firestore.collection("siswa").doc(uid).update(data);

        image = null;

        Get.back();
        Get.snackbar('Berhasil', "Berhasil ubah profil",
            icon: Icon(
              MdiIcons.checkBold,
              color: Colors.grey,
            ),
            backgroundColor: Colors.lightGreenAccent,
            duration: Duration(seconds: 4),
            animationDuration: Duration(seconds: 2),
            colorText: Colors.black);
      } catch (e) {
        Get.snackbar("Perhatian", "Tidak dapat ubah profil",
            icon: Icon(
              MdiIcons.alertBox,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            animationDuration: Duration(seconds: 2),
            colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> deleteProfile(String uid) async {
    try {
      firestore.collection("siswa").doc(uid).update({
        "profile": FieldValue.delete(),
      });
      Get.back();
      Get.snackbar("Berhasil", "Foto berhasil di hapus",
          icon: Icon(
            MdiIcons.checkBold,
            color: Colors.grey,
          ),
          backgroundColor: Colors.lightGreenAccent,
          duration: Duration(seconds: 4),
          animationDuration: Duration(seconds: 2),
          colorText: Colors.black);
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "Tidak dapat menghapus foto profil",
          icon: Icon(
            MdiIcons.alertBox,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          animationDuration: Duration(seconds: 2),
          colorText: Colors.white);
    } finally {
      update();
    }
  }
}
