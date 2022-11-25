import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../controllers/detek_waktu_controller.dart';

class DetekWaktuView extends GetView<DetekWaktuController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          'Tanggal tidak akurat',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PoppinLight',
                              color: Colors.lightBlue[400]),
                        ),
                      ),
                      Lottie.asset(
                        'assets/lottie/clock.json',
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                          'Tanggal dan waktu perangkat Anda tidak akurat. \n Sesuaikan waktu perangkat anda dan coba lagi.'),
                      SizedBox(height: 15),
                      Text(
                        'Waktu dan tanggal perangkat Anda adalah:',
                      ),
                      SizedBox(height: 5),
                      Text(
                        DateFormat("d/MMMM/yyyy HH:mm", "id_ID").format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: "PoppinLight",
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        child: Text('Atur Tanggal'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue[400],
                        ),
                        onPressed: () {
                          AppSettings.openDateSettings();
                          SystemNavigator.pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
