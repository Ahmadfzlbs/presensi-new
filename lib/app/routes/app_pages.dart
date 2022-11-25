import 'package:get/get.dart';

import 'package:smk1c/app/modules/add_siswa/bindings/add_siswa_binding.dart';
import 'package:smk1c/app/modules/add_siswa/views/add_siswa_view.dart';
import 'package:smk1c/app/modules/detek_waktu/bindings/detek_waktu_binding.dart';
import 'package:smk1c/app/modules/detek_waktu/views/detek_waktu_view.dart';
import 'package:smk1c/app/modules/home/bindings/home_binding.dart';
import 'package:smk1c/app/modules/home/views/home_view.dart';
import 'package:smk1c/app/modules/jadwal/bindings/jadwal_binding.dart';
import 'package:smk1c/app/modules/jadwal/views/jadwal_view.dart';
import 'package:smk1c/app/modules/login/bindings/login_binding.dart';
import 'package:smk1c/app/modules/login/views/login_view.dart';
import 'package:smk1c/app/modules/new_password/bindings/new_password_binding.dart';
import 'package:smk1c/app/modules/new_password/views/new_password_view.dart';
import 'package:smk1c/app/modules/profile/bindings/profile_binding.dart';
import 'package:smk1c/app/modules/profile/views/profile_view.dart';
import 'package:smk1c/app/modules/riwayat/bindings/riwayat_binding.dart';
import 'package:smk1c/app/modules/riwayat/views/riwayat_view.dart';
import 'package:smk1c/app/modules/update_profile/bindings/update_profile_binding.dart';
import 'package:smk1c/app/modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.ADD_SISWA,
      page: () => AddSiswaView(),
      binding: AddSiswaBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
        name: _Paths.PROFILE,
        page: () => ProfileView(),
        binding: ProfileBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
        name: _Paths.RIWAYAT,
        page: () => RiwayatView(),
        binding: RiwayatBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.DETEK_WAKTU,
      page: () => DetekWaktuView(),
      binding: DetekWaktuBinding(),
    ),
    GetPage(
        name: _Paths.JADWAL,
        page: () => JadwalView(),
        binding: JadwalBinding(),
        transition: Transition.fadeIn),
  ];
}
