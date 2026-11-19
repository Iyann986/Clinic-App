import 'package:clinic_app/app/data/repositories/auth_repository.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_snackbar.dart';
import 'package:clinic_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  static const genderOptions = ['Pria', 'Wanita'];

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;
  final selectedGender = Rxn<String>();

  DateTime? selectedBirthDate;

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama wajib diisi';
    return null;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi wajib diisi';
    }
    if (value != passwordController.text) return 'Kata sandi tidak sama';
    return null;
  }

  String? validateBirthDate(String? value) {
    if (selectedBirthDate == null) return 'Tanggal lahir wajib diisi';
    return null;
  }

  String? validateGender(String? value) {
    if (selectedGender.value == null) return 'Jenis kelamin wajib dipilih';
    return null;
  }

  String? validatePhone(String? value) {
    final digits = value?.trim() ?? '';
    if (digits.isEmpty) return 'Nomor telepon wajib diisi';
    if (digits.length < 9 || digits.length > 13) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return 'Alamat wajib diisi';
    return null;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void setGender(String? gender) {
    selectedGender.value = gender;
  }

  Future<void> pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          selectedBirthDate ?? DateTime(now.year - 17, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('id', 'ID'),
    );
    if (picked == null) return;

    selectedBirthDate = picked;
    birthDateController.text = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(picked);
  }

  void goToLogin() {
    Get.back();
  }

  Future<void> register() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (selectedGender.value == null) {
      CustomSnackbar.error('Jenis kelamin wajib dipilih');
      return;
    }
    if (selectedBirthDate == null) {
      CustomSnackbar.error('Tanggal lahir wajib diisi');
      return;
    }

    try {
      isLoading.value = true;

      final phoneDigits = phoneController.text.trim();
      final normalizedPhone = phoneDigits.startsWith('0')
          ? phoneDigits.substring(1)
          : phoneDigits;

      await _authRepository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        birthDate: DateFormat('yyyy-MM-dd').format(selectedBirthDate!),
        gender: selectedGender.value!,
        phoneNumber: '+62$normalizedPhone',
        address: addressController.text.trim(),
      );

      CustomSnackbar.success('Registrasi berhasil.');
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      CustomSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
