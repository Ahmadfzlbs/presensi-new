import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class JadwalController extends GetxController {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamJadwal() async* {
    String uid = auth.currentUser!.uid;

    var collection = FirebaseFirestore.instance.collection("siswa");
    var docKelas = await collection.doc(uid).get();
    Map<String, dynamic> data = docKelas.data()!;
    String kelas = data['kelas'];

    yield* firestore.collection("kelas").doc(kelas).snapshots();
  }

}
