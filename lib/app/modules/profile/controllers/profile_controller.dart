import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {

  RxBool isLoading = false.obs;
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    countData();
    count();
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore.collection("siswa").doc(uid).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> persentaseAbsen() async* {
    DateTime noww = DateTime.now();
    String uid = await auth.currentUser!.uid;
    String todayDocID = DateFormat.yMd().format(noww).replaceAll("/", "-");

    firestore.collection("siswa").doc(uid).collection("presensi").doc(todayDocID).snapshots();
  }

  Future<int> countData() async{
    DateTime noww = DateTime.now();
    String uid = await auth.currentUser!.uid;
    String todayDocID = DateFormat.yMd().format(noww).replaceAll("/", "-");
    final CollectionReference<Map<String, dynamic>> dataAbsen = FirebaseFirestore.instance.collection('siswa').doc(uid).collection('presensi');
    AggregateQuerySnapshot query = await dataAbsen.count().get();
    debugPrint('Number Data: ${query.count}');
    return query.count;
  }

  count() async{
    DateTime noww = DateTime.now();
    String uid = await auth.currentUser!.uid;
    String todayDocID = DateFormat.yMd().format(noww).replaceAll("/", "-");
    QuerySnapshot myCount = await firestore.collection('siswa').doc(uid).collection('presensi').doc(todayDocID).collection("masuk").get();
    List<DocumentSnapshot> DocCount = myCount.docs;
    print(DocCount.length);

  }

  Future<void> logout() async {
    isLoading.value = true;
    Get.defaultDialog(
        barrierDismissible: false,
        titlePadding: EdgeInsets.all(20),
        titleStyle: TextStyle(fontFamily: 'PoppinLight', fontWeight: FontWeight.bold),
        title: "Keluar Aplikasi",
        middleText:
        "Apakah kamu yakin untuk keluar aplikasi sekarang ?",
        middleTextStyle: TextStyle(fontFamily: 'PoppinLight'),
        actions: [
          OutlinedButton(
              onPressed: () => Get.back(),
              child: Text('Kembali')
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.LOGIN);
            },
            child: Text('Ya'),
          )
        ]
    );
  }

}
