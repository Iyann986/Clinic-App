import 'package:clinic_app/app/core/constant/storage.dart';
import 'package:clinic_app/app/data/services/local_service.dart';
import 'package:clinic_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final LocalService _localService = LocalService();

  @override
  void onInit() {
    super.onInit();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final firstTimeLaunch = await _localService.read(
      StorageKey.firstTimeLaunch,
    );
    final token = await _localService.read(StorageKey.tokenAccess);

    Future.delayed(const Duration(seconds: 2), () {
      // Sudah pernah login -> langsung masuk ke aplikasi.
      // TODO: ganti ke Routes.MAIN_WRAPPER begitu bottom navigation
      // (Chat/Telemedis/Riwayat/Profil) sudah dibuat.
      if (token != null) {
        Get.offAllNamed(Routes.HOME);
        return;
      }

      // Belum pernah buka aplikasi sama sekali -> tampilkan onboarding.
      if (firstTimeLaunch == null) {
        _localService.write(StorageKey.firstTimeLaunch, 'true');
        Get.offAllNamed(Routes.ONBOARDING);
        return;
      }

      // Pernah buka tapi belum/sudah logout -> langsung ke Login.
      Get.offAllNamed(Routes.LOGIN);
    });
  }
}
