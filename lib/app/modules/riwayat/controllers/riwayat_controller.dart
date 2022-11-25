import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RiwayatController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresensi() async* {
    String uid = await auth.currentUser!.uid;

    yield* firestore
        .collection("siswa")
        .doc(uid)
        .collection("presensi")
        .orderBy("tanggal")
        .limitToLast(5)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    String uid = await auth.currentUser!.uid;

    if (start == null) {
      return await firestore
          .collection("siswa")
          .doc(uid)
          .collection("presensi")
          .where("tanggal", isLessThan: end.toIso8601String())
          .orderBy("tanggal", descending: true)
          .get();
    } else {
      return await firestore
          .collection("siswa")
          .doc(uid)
          .collection("presensi")
          .where("tanggal", isGreaterThan: start!.toIso8601String())
          .where("tanggal", isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy("tanggal", descending: true)
          .get();
    }
  }

  void pickDate(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }
}
