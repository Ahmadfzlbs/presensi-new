import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kronos/flutter_kronos.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamRole() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("siswa").doc(uid).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamJadwal() async* {
    String uid = auth.currentUser!.uid;

    var collection = FirebaseFirestore.instance.collection("siswa");
    var docKelas = await collection.doc(uid).get();
    Map<String, dynamic> data = docKelas.data()!;
    String kelas = data['kelas'];

    yield* firestore.collection("kelas").doc(kelas).snapshots();
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresensi() async* {
    String uid = await auth.currentUser!.uid;

    String todayID = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore.collection("siswa").doc(uid).collection("presensi").doc(todayID).snapshots();
  }

  late Timer timer;
  late var timeNow;
  late bool error;

  DateTime? timeServer;

  @override
  void onInit() {
    super.onInit();
    cekLokasi();
    detekWaktu();
  }

  void detekWaktu() async {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

    if (!timezoneAuto || !timeAuto) {
      await Get.offAllNamed(Routes.DETEK_WAKTU);
    }
    else {
      print("Oke waktu sesuai");
    }
  }

  Future<void> cekLokasi() async {
    WidgetsFlutterBinding.ensureInitialized();
    var location = await Permission.location;
    if (await location.request().isLimited) {
      openAppSettings();
    } else if ( await location.request().isDenied) {
      openAppSettings();
    } else if (await location.request().isPermanentlyDenied) {
      openAppSettings();
    } else if (await location.request().isRestricted) {
      openAppSettings();
    } else {
      print("Oke");
    }
  }

  Future<void> initPlatformState() async {
    FlutterKronos.sync();
    timeNow = DateTime.now();
    timeServer = await FlutterKronos.getNtpDateTime;
    var time = await DateFormat('y/MM/d kk:mm').format(timeNow);
    var timeserver = await DateFormat('y/MM/d kk:mm').format(timeServer!);

    if (await time != await timeserver) {
      // PopupDetekWaktu('Pastikan waktu dan tanggal anda di set secara otomatis !');
      Get.snackbar("Perhatian",
          "Pastikan tanggal dan waktu anda di set secara otomatis !!",
          icon: Icon(
            MdiIcons.alertBox,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          animationDuration: Duration(seconds: 2),
          colorText: Colors.white);
    } else {}
  }

  Future<void> CekWifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      CheckBSSID();
    } else {
      // CheckWifiDialog("Belum terhubung kedalam jaringan Laboratorium RPL");
      Get.defaultDialog(
          barrierDismissible: false,
          title: "Perhatian !!",
          titlePadding: EdgeInsetsDirectional.all(10),
          middleText:
          "Belum terhubung kedalam jaringan Laboratorium RPL !!",
          actions: [
            ElevatedButton(
              onPressed: () async {
                AppSettings.openWIFISettings();
              },
              child: Text('Sambungkan'),
            )
          ]);
    }
  }

  void CheckBSSID() async {
    final info = NetworkInfo();
    var wifiBSSID = await info.getWifiBSSID();

    FlutterKronos.sync();
    timeNow = DateTime.now();
    timeServer = await FlutterKronos.getNtpDateTime;
    var time = await DateFormat('y/MM/d kk:mm').format(timeNow);
    var timeserver = await DateFormat('y/MM/d kk:mm').format(timeServer!);

    if (await Permission.location.serviceStatus.isEnabled == true) {
      if (wifiBSSID == 'c4:70:ab:81:d1:7b' && time == timeserver) {
        await Get.snackbar("Berhasil", "Anda telah mengisi absensi, Selamat belajar 🥰",
          icon: Icon(
              MdiIcons.checkBold,
              color: Colors.grey
          ),
          backgroundColor: Colors.lightGreenAccent,
          duration: Duration(seconds: 4),
        );
      } else if (wifiBSSID != 'c4:70:ab:81:d1:7b' && time == timeserver) {
        // showAlertDialog("Silahkan koneksikan jaringan anda ke Laboratorium RPL !");
        await Get.snackbar("Perhatian",
          "Silahkan koneksikan jaringan anda ke Laboratorium RPL !!",
          colorText: Colors.white,
          icon: Icon(
              MdiIcons.alertBox,
              color: Colors.white
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        );
      } else if (wifiBSSID != 'c4:70:ab:81:d1:7b' && time != timeserver) {
        // showAlertDialog("Periksa jaringan dan pastikan waktu di set secara otomatis !");
        await Get.snackbar("Perhatian",
          "Periksa jaringan dan pastikan waktu di set secara otomatis !!",
          colorText: Colors.white,
          icon: Icon(
              MdiIcons.alertBox,
              color: Colors.white
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        );
      } else if (wifiBSSID == 'c4:70:ab:81:d1:7b' && time != timeserver) {
        // PopupDetekWaktu("Pastikan waktu dan tanggal di set otomatis !");
        await Get.snackbar(
          "Perhatian", "Pastikan waktu dan tanggal di set otomatis !!",
          colorText: Colors.white,
          icon: Icon(
              MdiIcons.alertBox,
              color: Colors.white
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        );
      }
    } else {
      // DetekLokasi('Pastikan Lokasi anda Aktif !');
      await Get.snackbar("Perhatian", "Pastikan lokasi anda aktif !!",
        colorText: Colors.white,
        icon: Icon(
            MdiIcons.alertBox,
            color: Colors.white
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      );
    }
  }
}
