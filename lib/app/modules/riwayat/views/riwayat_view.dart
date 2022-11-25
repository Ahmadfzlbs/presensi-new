import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../controllers/page_index_controller.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.lightBlue[400],
          title: Text(
            "Riwayat Presensi Saya",
            style: TextStyle(
                fontSize: 18, fontFamily: "PoppinLight", color: Colors.white),
          ),
        ),
        body: GetBuilder<RiwayatController>(
          builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: controller.getPresence(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data?.docs.length == 0 || snapshot.data == null) {
                  return Center(
                    child: SizedBox(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Column(
                              children: [
                                Lottie.asset(
                                    "assets/lottie/empty.json",
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Belum ada riwayat presensi",
                                  style: TextStyle(
                                      fontFamily: 'PoppinLight',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlue[400]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index].data();
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.lightBlue[400]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Jam Masuk",
                                        style: TextStyle(
                                            fontFamily: 'PoppinLight',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        data["masuk"] == null
                                            ? '-'
                                            : "- Jam : ${DateFormat.Hm().format(DateTime.parse(data['masuk']['tanggal']))}",
                                        style: TextStyle(fontFamily: 'PoppinLight'),
                                      ),
                                    ],
                                  ),
                                  if (data["masuk"]['status'] == "Terlambat")
                                    Text(
                                      data["masuk"] == null
                                          ? '-'
                                          : '- Status : ${data['masuk']['status']}',
                                      style: TextStyle(
                                          fontFamily: 'PoppinLight',
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  if (data["masuk"]['status'] == "Tepat Waktu")
                                    Text(
                                      data["masuk"] == null
                                          ? '-'
                                          : '- Status : ${data['masuk']['status']}',
                                      style: TextStyle(
                                          fontFamily: 'PoppinLight',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Jam Pulang",
                                    style: TextStyle(
                                        fontFamily: 'PoppinLight',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data["keluar"] == null
                                        ? '- Jam : - '
                                        : "- Jam : ${DateFormat.Hm().format(DateTime.parse(data['keluar']['tanggal']))}",
                                    style: TextStyle(
                                        fontFamily: 'PoppinLight'),
                                  ),
                                  // Column(
                                  //   children: [
                                  //     Lottie.asset(
                                  //       "assets/lottie/date.json",
                                  //       width: 90,
                                  //     )
                                  //   ],
                                  // ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data['tanggal']))}",
                                        style: TextStyle(fontFamily: 'PoppinLight', fontSize: 13, color: Colors.lightBlue[400], fontWeight: FontWeight.bold),
                                      ),
                                      Lottie.asset(
                                        "assets/lottie/date.json",
                                        width: 100
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(Dialog(
              child: Container(
                  padding: EdgeInsets.all(20),
                  height: 400,
                  child: SfDateRangePicker(
                    monthViewSettings:
                        DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                    selectionMode: DateRangePickerSelectionMode.range,
                    showActionButtons: true,
                    onCancel: () => Get.back(),
                    onSubmit: (obj) {
                      if (obj != null) {
                        if ((obj as PickerDateRange).endDate != null) {
                          controller.pickDate(obj.startDate!, obj.endDate!);
                        }
                      }
                    },
                  )),
            ));
          },
          backgroundColor: Colors.lightBlue[400],
          elevation: 1,
          child: Icon(MdiIcons.calendar),
        ),
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
