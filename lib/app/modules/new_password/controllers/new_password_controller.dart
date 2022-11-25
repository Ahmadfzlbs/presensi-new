import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if(newPassC.text.isNotEmpty){
      if(newPassC.text != "password"){
        String email = auth.currentUser!.email!;
      await auth.currentUser!.updatePassword(newPassC.text);

      await auth.signOut();

      await auth.signInWithEmailAndPassword(email: email, password: newPassC.text);

      Get.offAllNamed(Routes.HOME);
    }else {
        Get.snackbar('Perhatian', 'Kata sandi baru tidak boleh sama !!');
      }
    }else {
      Get.snackbar('Perhatian', 'Kata sandi baru harus diisi !!');
    }
  }
}
