import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smk1c/app/controllers/page_index_controller.dart';
import '../../../../main.dart';
import '../controllers/home_controller.dart';
import 'package:timezone/timezone.dart' as tz1;

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    var detroit = tz1.getLocation('Asia/Bangkok');
    now = tz1.TZDateTime.now(detroit);
    double height = MediaQuery.of(context).size.height;

    DateTime noww = DateTime.now();
    String hh = DateFormat("HH", "id_ID").format(noww);
    String mm = DateFormat("mm", "id_ID").format(noww);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          backgroundColor: Colors.lightBlue[400],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/smk.png",
                alignment: Alignment.topLeft,
                height: 40,
                width: 40,
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.streamRole(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> user = snapshot.data!.data()!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Hi ${user["nama"]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'PoppinLight',
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Ada jadwal hari ini?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              fontFamily: 'PoppinLight',
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              SizedBox(
                width: 25,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamJadwal(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                Map<String, dynamic> jadwal = snapshot.data!.data()!;
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height / 1.9,
                        child: Stack(
                          children: [
                            Container(
                              height: height / 2.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                color: Colors.lightBlue[400],
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(45),
                                  bottomRight: Radius.circular(45),
                                ),
                              ),
                              child: SafeArea(
                                minimum: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: FlutterAnalogClock(
                                        dateTime: timeServer,
                                        dialPlateColor: Colors.white,
                                        hourHandColor: Colors.black,
                                        minuteHandColor: Colors.black,
                                        secondHandColor: Colors.red,
                                        numberColor: Colors.black,
                                        borderColor: Colors.white,
                                        tickColor: Colors.black,
                                        centerPointColor: Colors.black,
                                        showBorder: true,
                                        showTicks: true,
                                        showMinuteHand: true,
                                        showSecondHand: true,
                                        showNumber: true,
                                        borderWidth: 8.0,
                                        hourNumberScale: .70,
                                        hourNumbers: [
                                          '1',
                                          '2',
                                          '3',
                                          '4',
                                          '5',
                                          '6',
                                          '7',
                                          '8',
                                          '9',
                                          '10',
                                          '11',
                                          '12'
                                        ],
                                        isLive: true,
                                        width: 200.0,
                                        height: 200.0,
                                        decoration: const BoxDecoration(),
                                      ),
                                    ),
                                    SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat(
                                                  "EEEE, d MMMM yyyy", "id_ID")
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "PoppinLight",
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    StreamBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                        stream:
                                            controller.streamTodayPresensi(),
                                        builder: (context, snapToday) {
                                          if (snapToday.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          Map<String, dynamic>? dataToday =
                                              snapToday.data?.data();
                                          return Container(
                                            height: height * 0.15,
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                double innerHeight =
                                                    constraints.maxHeight;
                                                double innerWidth =
                                                    constraints.maxWidth;
                                                return Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Positioned(
                                                      bottom: 20,
                                                      left: 15,
                                                      right: 15,
                                                      child: Container(
                                                        height:
                                                            innerHeight * 0.60,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.grey[50],
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      'Absen Masuk',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'PoppinBold',
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        if (dataToday?["masuk"] ==
                                                                            null)
                                                                          Icon(
                                                                              MdiIcons.clockCheckOutline,
                                                                              color: Colors.red),
                                                                        if (dataToday?["masuk"] !=
                                                                            null)
                                                                          Icon(
                                                                              MdiIcons.clockCheckOutline,
                                                                              color: Colors.green),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          dataToday?["masuk"] == null
                                                                              ? "-"
                                                                              : "${DateFormat.Hm().format(DateTime.parse(dataToday!['masuk']['tanggal']))}",
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                39,
                                                                                105,
                                                                                171,
                                                                                1),
                                                                            fontFamily:
                                                                                'PoppinLight',
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        25,
                                                                    vertical: 8,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 2,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      'Absen Pulang',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'PoppinBold',
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        if (dataToday?["keluar"] ==
                                                                            null)
                                                                          Icon(
                                                                              MdiIcons.clockAlertOutline,
                                                                              color: Colors.red),
                                                                        if (dataToday?["keluar"] !=
                                                                            null)
                                                                          Icon(
                                                                              MdiIcons.clockCheckOutline,
                                                                              color: Colors.green),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          dataToday?["keluar"] == null
                                                                              ? '-'
                                                                              : "${DateFormat.Hm().format(DateTime.parse(dataToday!['keluar']['tanggal']))}",
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                39,
                                                                                105,
                                                                                171,
                                                                                1),
                                                                            fontFamily:
                                                                                'PoppinLight',
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jadwal Anda hari ini ya!',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'PoppinBold')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: int.parse(hh) == int.parse('${jadwal['jam_masuk']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_masuk']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_masuk']}'.substring(3, 5))+15
                                      ? Colors.lightBlue[400]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 5, bottom: 5),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          MdiIcons.calendar,
                                          color: int.parse(hh) == int.parse('${jadwal['jam_masuk']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_masuk']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_masuk']}'.substring(3, 5))+15
                                              ? Colors.white
                                              : Colors.lightBlue[400],
                                          size: 55,
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5)),
                                        Text(
                                          'Jadwal Masuk Anda hari ini',
                                          style: TextStyle(
                                              color: int.parse(hh) == int.parse('${jadwal['jam_masuk']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_masuk']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_masuk']}'.substring(3, 5))+15
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'PoppinLight'),
                                        ),
                                        Text(
                                          '${jadwal["jam_masuk"]}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: int.parse(hh) == int.parse('${jadwal['jam_masuk']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_masuk']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_masuk']}'.substring(3, 5))+15
                                                ? Colors.white
                                                : Colors.lightBlue[400],
                                            fontFamily: 'PoppinLight',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: int.parse(hh) == int.parse('${jadwal['jam_istirahat']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5))+15
                                      ? Colors.lightBlue[400]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 5, bottom: 5),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          MdiIcons.food,
                                          color: int.parse(hh) == int.parse('${jadwal['jam_istirahat']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5))+15
                                              ? Colors.white
                                              : Colors.lightBlue[400],
                                          size: 55,
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5)),
                                        Text(
                                          'Jadwal Istirahat Anda hari ini',
                                          style: TextStyle(
                                              color: int.parse(hh) == int.parse('${jadwal['jam_istirahat']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5))+15
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'PoppinLight'),
                                        ),
                                        Text(
                                          '${jadwal["jam_istirahat"]}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: int.parse(hh) == int.parse('${jadwal['jam_istirahat']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_istirahat']}'.substring(3, 5))+15
                                                ? Colors.white
                                                : Colors.lightBlue[400],
                                            fontFamily: 'PoppinLight',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: int.parse(hh) == int.parse('${jadwal['jam_pulang']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_pulang']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_pulang']}'.substring(3, 5))+15
                                      ? Colors.lightBlue[400]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 5, bottom: 5),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          MdiIcons.exitRun,
                                          color: int.parse(hh) == int.parse('${jadwal['jam_pulang']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_pulang']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_pulang']}'.substring(3, 5))+15
                                              ? Colors.white
                                              : Colors.lightBlue[400],
                                          size: 55,
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5)),
                                        Text(
                                          'Jadwal Istirahat Anda hari ini',
                                          style: TextStyle(
                                              color: int.parse(hh) == int.parse('${jadwal['jam_pulang']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_pulang']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_pulang']}'.substring(3, 5))+15
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'PoppinLight'),
                                        ),
                                        Text(
                                          '${jadwal["jam_pulang"]}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: int.parse(hh) == int.parse('${jadwal['jam_pulang']}'.substring(0,2)) && int.parse(mm) >= int.parse('${jadwal['jam_pulang']}'.substring(3, 5)) && int.parse(mm) <= int.parse('${jadwal['jam_pulang']}'.substring(3, 5))+15
                                                ? Colors.white
                                                : Colors.lightBlue[400],
                                            fontFamily: 'PoppinLight',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        bottomNavigationBar: ConvexAppBar(
          height: 60,
          style: TabStyle.fixedCircle,
          backgroundColor: Colors.lightBlue[400],
          items: [
            TabItem(
                icon: MdiIcons.home,
                title: 'Beranda',
                fontFamily: 'PoppinLight'),
            TabItem(
                icon: MdiIcons.history,
                title: 'Riwayat',
                fontFamily: 'PoppinLight'),
            TabItem(
                icon: MdiIcons.fingerprint,
                title: '',
                fontFamily: 'PoppinLight'),
            TabItem(
                icon: MdiIcons.calendarMultiple,
                title: 'Jadwal',
                fontFamily: 'PoppinLight'),
            TabItem(
                icon: Icons.person, title: 'Akun', fontFamily: 'PoppinLight'),
          ],
          initialActiveIndex: pageC.pagIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
