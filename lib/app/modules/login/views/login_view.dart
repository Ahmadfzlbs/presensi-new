import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  late String errormsg;
  late bool error, showprogress;
  bool submit = false;
  late String nis, password;

  bool _isHidePassword = true;
  bool isloading = true;

  void _togglePassword() {
    _isHidePassword = !_isHidePassword;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.lightBlue[300]),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
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
                              child: Container(
                                height: innerHeight * 0.80,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: TextFormField(
                                          controller: controller.emailC,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ("Masukan Email anda");
                                            }
                                            return null;
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          cursorColor: Color(0xFF000000),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.lightBlue),
                                            ),
                                            focusColor: Colors.grey,
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.lightBlue[300],
                                            ),
                                            prefixStyle: TextStyle(
                                                decorationColor: Colors.grey,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'PoppinLight'),
                                            labelText: "Email",
                                            hintText:
                                                "youremail@gmail.com",
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w200),
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20, 15, 20, 15),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Obx(
                                        () => TextFormField(
                                            controller: controller.passwordC,
                                            keyboardType: TextInputType.text,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              RegExp regex =
                                                  new RegExp(r'^.{6,}$');
                                              if (value!.isEmpty) {
                                                return ("Masukan kata sandi anda");
                                              }
                                              if (!regex.hasMatch(value)) {
                                                return ("Masukan kata sandi (Minimal 6 karakter)");
                                              }
                                            },
                                            obscureText: controller.obsecureText.value,
                                            cursorColor: Color(0xFF000000),
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.lightBlue),
                                              ),
                                              suffixIcon:IconButton(
                                                icon: (controller.obsecureText != false) ? Icon(Icons.visibility_off, color: Colors.grey,) : Icon(Icons.visibility, color: Colors.lightBlue[400],),
                                                onPressed: () {
                                                  controller.obsecureText.value = !(controller.obsecureText.value);
                                                },
                                              ),
                                              focusColor: Colors.grey,
                                              prefixIcon: Icon(
                                                CupertinoIcons.lock_fill,
                                                color: Colors.lightBlue[300],
                                              ),
                                              prefixStyle: TextStyle(
                                                  decorationColor: Colors.grey,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'PoppinLight'),
                                              labelText: "Kata sandi",
                                              hintText: "Masukan kata sandi",
                                              hintStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w200),
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              contentPadding: EdgeInsets.fromLTRB(
                                                  20, 15, 20, 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                        height: 40,
                                        width: 270,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Obx(
                                          () => ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                primary: Colors.lightBlue[300],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            onPressed: () async {
                                              if (controller.isLoading.isFalse) {
                                                await controller.login();
                                              }
                                            },
                                            child: Text(
                                              controller.isLoading.isFalse
                                                  ? "Masuk"
                                                  : "Tunggu...",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: width * 0.45,
                                  height: height * 0.22,
                                  child: Image.asset(
                                    "assets/images/smk.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
