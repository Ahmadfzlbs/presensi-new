import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kronos/flutter_kronos.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pagIndex = 0.obs;
  final navigatorKey = GlobalKey<NavigatorState>();

  var BSSIDList = [
    'c4:70:ab:81:d1:7b',
    '84:16:f9:8c:24:1e',
    'f4:4c:7f:ad:7d:c4'
  ];

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() async {
    super.onInit();
    await detekWaktu();
  }

  void changePage(int i) async {
    switch (i) {
      case 1:
        pagIndex.value = i;
        Get.offAllNamed(Routes.RIWAYAT);
        break;
      case 2:
        CekWifi();
        break;
      case 3:
        pagIndex.value = i;
        Get.offAllNamed(Routes.JADWAL);
        break;
      case 4:
        pagIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pagIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi() async {
    String uid = await auth.currentUser!.uid;

    var collection = FirebaseFirestore.instance.collection("siswa");
    var docKelas = await collection.doc(uid).get();
    Map<String, dynamic> data = docKelas.data()!;
    String kelas = data['kelas'];

    var jdwl = FirebaseFirestore.instance.collection("kelas");
    var jamJdwl = await jdwl.doc(kelas).get();
    Map<String, dynamic> datas = jamJdwl.data()!;

    String hariOne = datas['hari_pertama'];
    String hariTwo = datas['hari_kedua'];

    String jamMsk = datas['jam_masuk'];
    String jamMskJam = jamMsk.substring(0, 2);
    String jamMskMnt = jamMsk.substring(3, 5);

    String jamPlg = datas['jam_pulang'];
    String jamPlgJam = jamPlg.substring(0, 2);
    String jamPlgMnt = jamPlg.substring(3, 5);

    CollectionReference<Map<String, dynamic>> colPresensi =
        await firestore.collection("siswa").doc(uid).collection("presensi");

    QuerySnapshot<Map<String, dynamic>> snapPresensi = await colPresensi.get();

    DateTime noww = DateTime.now();
    // String hariPertama = 'Senin';
    // String hariKedua = 'Selasa';
    String today = DateFormat("EEEE", "id_ID").format(noww);

    TimeOfDay now = TimeOfDay.now();
    TimeOfDay jamMasuk =
        TimeOfDay(hour: int.parse(jamMskJam), minute: int.parse(jamMskMnt));

    jamMasuk.toString();

    TimeOfDay jamPulang =
        TimeOfDay(hour: int.parse(jamPlgJam), minute: int.parse(jamPlgMnt));
    TimeOfDay limitJamPulang = TimeOfDay(hour: 24, minute: 00);

    jamPulang.toString();
    limitJamPulang.toString();

    int masukAbsen = jamMasuk.hour * 60 + jamMasuk.minute;
    int limitAbsenMasuk = jamMasuk.hour * 60 + jamMasuk.minute + 15;

    int pulangAbsen = jamPulang.hour * 60 + jamPulang.minute;
    int limitAbsenPulang = limitJamPulang.hour * 60 + limitJamPulang.minute;

    int mulai = now.hour * 60 + now.minute;

    String todayDocID = DateFormat.yMd().format(noww).replaceAll("/", "-");

    if (snapPresensi.docs.length == 0) {
      if (today != hariOne && today != hariTwo) {
        Get.defaultDialog(
            title: "Perhatian",
            middleText: "Tidak ada jadwal pembelajaran, silahkan periksa kembali jadwal pelajaran anda !!",
            titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
            middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
            titlePadding: EdgeInsets.all(20),
            barrierDismissible: false,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Oke"))
            ]);
      } else {
        if (mulai < masukAbsen) {
          Get.defaultDialog(
              title: "Perhatian",
              middleText: "Belum waktunya untuk mengisi Presensi Masuk !!",
              titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
              middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
              titlePadding: EdgeInsets.all(20),
              barrierDismissible: false,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Oke"))
              ]);
        } else if (mulai >= masukAbsen && mulai <= limitAbsenMasuk) {
          await colPresensi.doc(todayDocID).set({
            "tanggal": timeNow.toIso8601String(),
            "masuk": {
              "tanggal": timeNow.toIso8601String(),
              "status": "Tepat Waktu",
            }
          });
          await Get.snackbar(
            "Berhasil",
            "Anda telah mengisi Presensi Masuk",
            icon: Icon(MdiIcons.checkBold, color: Colors.grey),
            backgroundColor: Colors.lightGreenAccent,
            duration: Duration(seconds: 4),
          );
        } else {
          await colPresensi.doc(todayDocID).set({
            "tanggal": noww.toIso8601String(),
            "masuk": {
              "tanggal": noww.toIso8601String(),
              "status": "Terlambat",
            }
          });
          await Get.snackbar(
            "Berhasil",
            "Anda telah mengisi Presensi Masuk",
            icon: Icon(MdiIcons.checkBold, color: Colors.grey),
            backgroundColor: Colors.lightGreenAccent,
            duration: Duration(seconds: 4),
          );
        }
      }
    } else {
      //Sudah pernah absen -> cek hari ini udah absen masuk/keluar belum ?

      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresensi.doc(todayDocID).get();
      if (todayDoc.exists == true) {
        //tinggal absen keluar atau sudah absen masuk & keluar

        Map<String, dynamic>? dataPresensiToday = todayDoc.data();
        if (dataPresensiToday?["keluar"] != null) {
          await Get.defaultDialog(
              title: "Perhatian",
              middleText: "Kamu telah mengisi Presensi Masuk & Pulang !!",
              titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
              middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
              titlePadding: EdgeInsets.all(20),
              barrierDismissible: false,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Oke"))
              ]);
        } else {
          //absen keluar
          if (mulai < pulangAbsen) {
            Get.defaultDialog(
                title: "Perhatian !!",
                middleText: "Belum waktunya untuk mengisi Presensi Pulang !!",
                titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
                middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
                titlePadding: EdgeInsets.all(20),
                barrierDismissible: false,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Oke"))
                ]);
          } else if (mulai >= pulangAbsen && mulai <= limitAbsenPulang) {
            await colPresensi.doc(todayDocID).update({
              "keluar": {
                "tanggal": timeNow.toIso8601String(),
                "status": "Pulang Tepat Waktu",
              }
            });
            await Get.snackbar(
              "Berhasil",
              "Anda telah mengisi Presensi Pulang",
              icon: Icon(MdiIcons.checkBold, color: Colors.grey),
              backgroundColor: Colors.lightGreenAccent,
              duration: Duration(seconds: 4),
            );
          } else {
            Get.defaultDialog(
                title: "Perhatian",
                middleText: "Kamu tidak bisa Presensi Pulang karena melebihi batas waktu !!",
                titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
                middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
                titlePadding: EdgeInsets.all(20),
                barrierDismissible: false,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Oke"))
                ]);
          }
        }
      } else {
        //absen masuk
        if (mulai < masukAbsen) {
          Get.defaultDialog(
              title: "Perhatian",
              middleText: "Belum waktunya untuk mengisi Presensi Masuk !!",
              titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
              middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
              titlePadding: EdgeInsets.all(20),
              barrierDismissible: false,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Oke"))
              ]);
        } else if (mulai >= masukAbsen && mulai <= limitAbsenMasuk) {
          await colPresensi.doc(todayDocID).set({
            "tanggal": timeNow.toIso8601String(),
            "masuk": {
              "tanggal": timeNow.toIso8601String(),
              "status": "Tepat Waktu",
            }
          });
          await Get.snackbar(
            "Berhasil",
            "Anda telah mengisi Presensi Masuk",
            icon: Icon(MdiIcons.checkBold, color: Colors.grey),
            backgroundColor: Colors.lightGreenAccent,
            duration: Duration(seconds: 4),
          );
        } else {
          if (today != hariOne && today != hariTwo) {
            Get.defaultDialog(
                title: "Perhatian",
                middleText: "Tidak ada jadwal pembelajaran, silahkan periksa kembali jadwal pelajaran anda !!",
                titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
                middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
                titlePadding: EdgeInsets.all(20),
                barrierDismissible: false,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Oke"))
                ]);
          } else {
            await colPresensi.doc(todayDocID).set({
              "tanggal": noww.toIso8601String(),
              "masuk": {
                "tanggal": noww.toIso8601String(),
                "status": "Terlambat",
              }
            });
            await Get.snackbar(
              "Berhasil",
              "Anda telah mengisi Presensi Masuk",
              icon: Icon(MdiIcons.checkBold, color: Colors.grey),
              backgroundColor: Colors.lightGreenAccent,
              duration: Duration(seconds: 4),
            );
          }
        }
      }
    }
  }

  late Timer timer;
  late var timeNow;
  late bool error;

  DateTime? timeServer;

  Future<void> detekWaktu() async {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

    if (!timezoneAuto || !timeAuto) {
      await Get.offAllNamed(Routes.DETEK_WAKTU);
    } else {
      print("Oke waktu sesuai");
    }
  }

  Future<void> CekWifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      CheckBSSID();
    } else {
      // CheckWifiDialog("Belum terhubung kedalam jaringan Laboratorium RPL");
      Get.snackbar(
          "Perhatian", "Belum terhubung kedalam jaringan Laboratorium RPL !!",
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

  void CheckBSSID() async {
    final info = NetworkInfo();
    var wifiBSSID = await info.getWifiBSSID();

    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

    if (await Permission.location.serviceStatus.isEnabled != true) {
      // DetekLokasi('Pastikan Lokasi anda Aktif !');
      await Get.snackbar(
        "Perhatian",
        "Pastikan lokasi anda aktif !!",
        colorText: Colors.white,
        icon: Icon(MdiIcons.alertBox, color: Colors.white),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      );
    } else if (wifiBSSID == '74:83:c2:87:a9:9f' && timezoneAuto && timeAuto) {
      await presensi();
    } else if (!timeAuto || !timezoneAuto) {
      await Get.snackbar(
        "Perhatian",
        "Pastikan waktu dan tanggal anda di set otomatis !!",
        colorText: Colors.white,
        icon: Icon(MdiIcons.alertBox, color: Colors.white),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      );
    } else {
      await Get.snackbar(
        "Perhatian",
        "Silahkan koneksikan jaringan anda ke Laboratorium RPL !!",
        colorText: Colors.white,
        icon: Icon(MdiIcons.alertBox, color: Colors.white),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      );
    }
  }
}
