import 'package:clinic_app/app/core/constant/app_config.dart';
import 'package:clinic_app/app/data/repositories/auth_repository.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_snackbar.dart';
import 'package:clinic_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi wajib diisi';
    if (value.length < 6) return 'Kata sandi minimal 6 karakter';
    return null;
  }

  Future<void> login() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    try {
      isLoading.value = true;
      await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      _goToHomeAfterLogin();
    } catch (e) {
      CustomSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;

      String idToken = 'dummy-id-token';

      // Selama Google Sign-In di backend belum sempurna, jangan sentuh
      // SDK Google asli sama sekali (bisa crash kalau OAuth client belum
      // dikonfigurasi) — langsung pakai token dummy di atas.
      if (!AppConfig.useMockLoginGoogle) {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut(); // supaya user selalu bisa pilih akun
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) return; // dibatalkan oleh user

        final googleAuth = await googleUser.authentication;
        final googleIdToken = googleAuth.idToken;
        if (googleIdToken == null) {
          CustomSnackbar.error('Gagal mendapatkan token dari Google.');
          return;
        }
        idToken = googleIdToken;
      }

      await _authRepository.loginGoogle(idToken);
      _goToHomeAfterLogin();
    } catch (e) {
      CustomSnackbar.error(e.toString());
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void _goToHomeAfterLogin() {
    // TODO: ganti ke Routes.MAIN_WRAPPER begitu bottom navigation
    // (Chat/Telemedis/Riwayat/Profil) sudah dibuat.
    Get.offAllNamed(Routes.HOME);
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void goToForgotPassword() {
    CustomSnackbar.info('Fitur lupa kata sandi belum tersedia.');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
