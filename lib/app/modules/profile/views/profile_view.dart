import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:d_chart/d_chart.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';


class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue[100]!,
                Colors.lightBlue[400]!,
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue[400],
            title: Text(
              "Profile Saya",
              style: TextStyle(
                  fontSize: 20, fontFamily: "PoppinLight", color: Colors.white),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  Map<String, dynamic> user = snapshot.data!.data()!;
                  String defaultImage = "https://forum.truckersmp.com/uploads/monthly_2020_03/imported-photo-202022.thumb.png.81943bfe1be32614be2b23043e189bd5.png";
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.55,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double innerHeight = constraints.maxHeight;
                                double innerWidth = constraints.maxWidth;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          height: innerHeight * 0.80,
                                          width: innerWidth,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 80,
                                              ),
                                              Text(
                                                "${user["nama"]}",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 105, 171, 1),
                                                  fontFamily: 'PoppinLight',
                                                  fontSize: 25,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                        Text(
                                                          'NIS',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                            'PoppinBold',
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${user["nis"]}',
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              39, 105, 171, 1),
                                                          fontFamily:
                                                              'PoppinLight',
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${user["kelas"]}',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 105, 171, 1),
                                                  fontFamily: 'PoppinLight',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Container(
                                                  height: 40,
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: ElevatedButton.icon(
                                                    icon:
                                                        Icon(MdiIcons.accountEdit),
                                                    style: ElevatedButton.styleFrom(
                                                        elevation: 0.0,
                                                        primary:
                                                            Colors.lightBlue[300],
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                    onPressed: () async {
                                                      Get.toNamed(
                                                          Routes.UPDATE_PROFILE,
                                                          arguments: user);
                                                    },
                                                    label: Text(
                                                      "Edit profil",
                                                      style: TextStyle(
                                                          fontFamily: 'PoppinLight',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Container(
                                                  height: 40,
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                                  child: ElevatedButton.icon(
                                                    icon:
                                                    Icon(MdiIcons.exitToApp),
                                                    style: ElevatedButton.styleFrom(
                                                        elevation: 0.0,
                                                        primary:
                                                        Colors.lightBlue[300],
                                                        shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20))),
                                                    onPressed: () async {
                                                      await controller.logout();
                                                    },
                                                    label: Text(
                                                      "Keluar",
                                                      style: TextStyle(
                                                          fontFamily: 'PoppinLight',
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //   top: 110,
                                    //   right: 20,
                                    //   child: Icon(
                                    //     CupertinoIcons.settings,
                                    //     color: Colors.grey[700],
                                    //     size: 30,
                                    //   ),
                                    // ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: ClipOval(
                                          child: Container(
                                            height: 170,
                                            width: 170,
                                            child: Image.network(
                                              user["profile"] != null
                                                  ? user["profile"] != ""
                                                      ? user["profile"]
                                                      : defaultImage
                                                  : defaultImage,
                                              fit: BoxFit.cover,
                                            ),
                                            //   backgroundColor: Colors.grey,
                                            //   onPressed: () {
                                            //     Get.toNamed(Routes.UPDATE_PROFILE, arguments: user);
                                            //     // controller.izinCamera();
                                            //   },
                                            // ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            bottomNavigationBar:
            // DotNavigationBar(
            //   backgroundColor: Colors.lightBlue[400],
            //   currentIndex: pageC.pagIndex.value,
            //   dotIndicatorColor: Colors.white,
            //   unselectedItemColor: Colors.white,
            //   onTap: (int i) => pageC.changePage(i),
            //   items: [
            //     DotNavigationBarItem(
            //       icon: Icon(MdiIcons.homeCircle,
            //         size: 25,
            //       ),
            //       selectedColor: Colors.white,
            //     ),
            //     DotNavigationBarItem(
            //       icon: Icon(MdiIcons.history,
            //         size: 25,
            //       ),
            //       selectedColor: Colors.white,
            //     ),
            //     DotNavigationBarItem(
            //       icon: Icon(CupertinoIcons.person_crop_circle,
            //         size: 25,
            //       ),
            //       selectedColor: Colors.white,
            //     ),
            //   ],
            // ),
            //
          ConvexAppBar(
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
            )
        )
      ],
    );
  }
}
