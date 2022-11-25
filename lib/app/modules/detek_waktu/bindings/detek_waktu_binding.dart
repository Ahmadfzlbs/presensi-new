import 'package:get/get.dart';

import '../controllers/detek_waktu_controller.dart';

class DetekWaktuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetekWaktuController>(
      () => DetekWaktuController(),
    );
  }
}
