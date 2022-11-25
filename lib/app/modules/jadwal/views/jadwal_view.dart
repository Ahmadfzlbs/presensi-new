import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../controllers/page_index_controller.dart';
import '../controllers/jadwal_controller.dart';

class JadwalView extends GetView<JadwalController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.lightBlue[400],
          title: Text(
            "Jadwal Saya",
            style: TextStyle(
                fontSize: 18, fontFamily: "PoppinLight", color: Colors.white),
          ),
        ),
        body: StreamBuilder(
          stream: controller.streamJadwal(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
            Map<String, dynamic> jadwal = snapshot.data!.data()!;
            return Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Lottie.asset(
                      "assets/lottie/empty.json",
                      height: 300,
                      width: MediaQuery.of(context).size.width
                    ),
                    // Text("Jadwal hari ini",
                    // style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontFamily: 'PoppinLight',
                    //     fontSize: 15
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                "assets/images/smk.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(MdiIcons.clock, color: Colors.lightBlue[500]),
                                    SizedBox(width: 5),
                                    Text('${jadwal["jam_masuk"]}',
                                      style: TextStyle(
                                          fontFamily: 'PoppinLight',
                                          color: Colors.grey[700],
                                          fontSize: 15
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text('-',
                                      style: TextStyle(
                                          fontFamily: 'PoppinLight',
                                          color: Colors.grey[700],
                                          fontSize: 15
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text('${jadwal["jam_pulang"]}',
                                      style: TextStyle(
                                          fontFamily: 'PoppinLight',
                                          color: Colors.grey[700],
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text('${jadwal["mata_pelajaran"]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PoppinLight',
                                      fontSize: 15
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_rounded, color: Colors.red),
                                    SizedBox(width: 5),
                                    Text("Laboratium RPL",
                                      style: TextStyle(
                                          fontFamily: 'PoppinLight',
                                          color: Colors.grey[700],
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        bottomNavigationBar:  ConvexAppBar(
          height: 60,
          style: TabStyle.fixedCircle,
          backgroundColor: Colors.lightBlue[400],
          items: [
            TabItem(icon: MdiIcons.home, title: 'Beranda', fontFamily: 'PoppinLight'),
            TabItem(icon: MdiIcons.history, title: 'Riwayat', fontFamily: 'PoppinLight'),
            TabItem(icon: MdiIcons.fingerprint, title: '', fontFamily: 'PoppinLight'),
            TabItem(icon: MdiIcons.calendarMultiple, title: 'Jadwal', fontFamily: 'PoppinLight'),
            TabItem(icon: Icons.person, title: 'Akun', fontFamily: 'PoppinLight'),
          ],
          initialActiveIndex: pageC.pagIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
