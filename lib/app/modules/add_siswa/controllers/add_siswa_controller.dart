import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddSiswaController extends GetxController {
  onClose() {
    nisC.dispose();
    namaC.dispose();
    emailC.dispose();
    passAdminC.dispose();
  }

  RxBool isLoading = false.obs;
  RxBool isLoadingAddSiswa = false.obs;

  TextEditingController nisC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController kelasC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddSiswa() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddSiswa.value = true;
      String emailAdmin = auth.currentUser!.email!;
      try {
        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

        UserCredential siswaCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (siswaCredential.user != null) {
          String uid = siswaCredential.user!.uid;

          await firestore.collection("siswa").doc(uid).set({
            "nis": nisC.text,
            "email": emailC.text,
            "nama": namaC.text,
            "uid": uid,
            "udid": "",
            "role": "siswa",
            "kelas": kelasC.text,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await siswaCredential.user!.sendEmailVerification();

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passAdminC.text);

          Get.back();
          Get.back();

          Get.snackbar("Sukses", "Berhasil menambahkan siswa",
              icon: Icon(
                MdiIcons.checkBold,
                color: Colors.grey,
              ),
              backgroundColor: Colors.lightGreenAccent,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.black);
        }
        isLoadingAddSiswa.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAddSiswa.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Perhatian", "Kata sandi anda salah !!",
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Perhatian", "Email ini telah digunakan !!",
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        } else if (e.code == 'invalid-email') {
          Get.snackbar("Perhatian", "Email yang anda masukan tidak valid !!",
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Perhatian", "Kata sandi anda salah !!",
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        } else if (e.code == 'network-request-failed') {
          Get.snackbar("Perhatian", "Tidak ada koneksi Jaringan !!",
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        } else {
          Get.snackbar("Perhatian", "${e.code}",
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        }
      } catch (e) {
        isLoadingAddSiswa.value = false;
        Get.snackbar("Perhatian", "Tidak dapat menambahkan Siswa !!",
            icon: Icon(
              MdiIcons.alertBox,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            animationDuration: Duration(seconds: 2),
            colorText: Colors.white);
      }
      isLoadingAddSiswa.value = false;
    } else {
      Get.snackbar("Perhatian", "Kata sandi harus diisi !!",
          icon: Icon(
            MdiIcons.alertBox,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          animationDuration: Duration(seconds: 2),
          colorText: Colors.white);
    }
  }

  Future<void> addSiswa() async {
    isLoading.value = true;
    if (nisC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        namaC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Kata sandi",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
              )
            ],
          ),
          actions: [
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddSiswa.isFalse) {
                    await prosesAddSiswa();
                  }
                  isLoading.value = false;
                },
                child: Text(
                    isLoadingAddSiswa.isFalse ? "Tambah Siswa" : "Tunggu..."),
              ),
            ),
            OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: Text("Kembali"))
          ]);
    } else {
      Get.snackbar("Perhatian", "Harap isi bagian yang Kosong !!",
          icon: Icon(
            MdiIcons.alertBox,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          animationDuration: Duration(seconds: 2),
          colorText: Colors.white);
    }
  }
}
