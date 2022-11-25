import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_udid/flutter_udid.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    cekPhone();
  }

  RxBool obsecureText = true.obs;
  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController namaC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> login() async {
    isLoading.value = true;
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );
        if (userCredential.user != null) {
          String uid = await userCredential.user!.uid;
          String udid = await FlutterUdid.udid;

          var collection = FirebaseFirestore.instance.collection("siswa");
          var docUdid = await collection.doc(uid).get();
          Map<String, dynamic> data = docUdid.data()!;
          String udidf = data['udid'];

          if (udidf == '' || udidf == udid) {
            await collection.doc(uid).update({
              "udid": udid,
            });
            if (userCredential.user!.emailVerified == true) {
              isLoading.value = false;
              if (passwordC.text == "password") {
                Get.offAllNamed(Routes.NEW_PASSWORD);
              } else {
                Get.offAllNamed(Routes.HOME);
                Get.snackbar('Sukses', 'Selamat datang di Presensi RPL',
                    icon: Icon(
                      MdiIcons.checkBold,
                      color: Colors.grey,
                    ),
                    backgroundColor: Colors.lightGreenAccent,
                    duration: Duration(seconds: 4),
                    animationDuration: Duration(seconds: 2),
                    colorText: Colors.black);
              }
            } else {
              Get.defaultDialog(
                  title: "Belum Verifikasi",
                  middleText:
                      "Kamu belum memverifikasi akun ini. Cek email kamu untuk melakukan verifikasi.",
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          isLoading.value = false;
                          Get.back();
                        },
                        child: Text('Kembali')),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await userCredential.user!.sendEmailVerification();
                          Get.back();
                          Get.snackbar('Berhasil',
                              'Kami telah mengirim verifikasi ke email kamu.',
                              icon: Icon(
                                MdiIcons.checkBold,
                                color: Colors.grey,
                              ),
                              backgroundColor: Colors.lightGreenAccent,
                              duration: Duration(seconds: 4),
                              animationDuration: Duration(seconds: 2),
                              colorText: Colors.white);
                          isLoading.value = false;
                        } catch (e) {
                          isLoading.value = false;
                          Get.snackbar('Terjadi Kesalahan',
                              'Tidak dapat mengirim email verifikasi, Hubungi admin untuk lebih lanjut.',
                              icon: Icon(
                                MdiIcons.alertBox,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 4),
                              animationDuration: Duration(seconds: 2),
                              colorText: Colors.white);
                        }
                      },
                      child: Text('Kirim Verifikasi Ulang'),
                    )
                  ]);
            }
          } else {
            Get.defaultDialog(
                title: "Perhatian",
                middleText: "Anda tidak bisa login di Device lain !!",
                titlePadding: EdgeInsets.all(20),
                barrierDismissible: false,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Oke"))
                ]);
            FirebaseAuth.instance.signOut();
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar('Perhatian', 'Username tidak ditemukan !!',
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        } else if (e.code == 'invalid-email') {
          Get.snackbar('Perhatian', 'Email yang anda masukan tidak valid !!',
              icon: Icon(
                MdiIcons.alertBox,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
              colorText: Colors.white);
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Perhatian', 'Password yang anda masukan salah !!',
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
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Perhatian", "Tidak dapat Login !!",
            icon: Icon(
              MdiIcons.alertBox,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            animationDuration: Duration(seconds: 2),
            colorText: Colors.white);
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Perhatian", "Email dan Password harus diisi !!",
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

  Future<void> cekPhone() async {
    WidgetsFlutterBinding.ensureInitialized();
    var phone = await Permission.phone;
    if (await phone.request().isLimited) {
      openAppSettings();
    } else if (await phone.request().isDenied) {
      openAppSettings();
    } else if (await phone.request().isPermanentlyDenied) {
      openAppSettings();
    } else if (await phone.request().isRestricted) {
      openAppSettings();
    } else {
      print("Oke");
    }
  }
}
