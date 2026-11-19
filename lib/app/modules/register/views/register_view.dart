import 'package:clinic_app/app/assets/resource_path.dart';
import 'package:clinic_app/app/core/constant/colors.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_button.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                Center(
                  child: Image.asset(
                    ResourcePath.logoSehatmuPng,
                    color: AppColors.primary,
                    height: 110,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Daftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Buat akun baru untuk melanjutkan ke Sehatmu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.lightGray),
                ),
                const SizedBox(height: 32),

                // nama lengkap
                CustomTextField(
                  label: 'Nama',
                  hint: 'Masukkan Nama Lengkap',
                  prefixIcon: Icons.person,
                  controller: controller.nameController,
                  keyboardType: TextInputType.text,
                  validator: controller.validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  label: 'Email',
                  hint: 'Masukkan Email',
                  prefixIcon: Icons.email_outlined,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),

                // password
                Obx(
                  () => CustomTextField(
                    label: 'Kata Sandi',
                    hint: 'Masukkan Kata Sandi',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: controller.obscurePassword.value,
                    onTogglePassword: controller.togglePasswordVisibility,
                    controller: controller.passwordController,
                    validator: controller.validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                const SizedBox(height: 16),

                // confirm password
                Obx(
                  () => CustomTextField(
                    label: 'Konfirmasi Kata Sandi',
                    hint: 'Masukkan Konfirmasi Kata Sandi',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: controller.obscureConfirmPassword.value,
                    onTogglePassword:
                        controller.toggleConfirmPasswordVisibility,
                    controller: controller.confirmPasswordController,
                    validator: controller.validateConfirmPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                const SizedBox(height: 16),

                // birth date
                CustomTextField(
                  label: 'Tanggal Lahir',
                  hint: 'Masukkan Tanggal Lahir',
                  prefixIcon: Icons.calendar_today_outlined,
                  suffixIcon: Icons.calendar_month_outlined,
                  controller: controller.birthDateController,
                  readOnly: true,
                  onTap: () => controller.pickBirthDate(context),
                  validator: controller.validateBirthDate,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),

                // gender
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Kelamin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedGender.value,
                        decoration: InputDecoration(
                          hintText: 'Pilih Jenis Kelamin',
                          prefixIcon: Icon(
                            Icons.wc_outlined,
                            color: AppColors.veryLightGray,
                            size: 22,
                          ),
                        ),
                        items: RegisterController.genderOptions
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                        onChanged: controller.setGender,
                        validator: controller.validateGender,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // phone number
                CustomTextField(
                  label: 'No. Telepon',
                  hint: '812-3456-7890',
                  prefixIcon: Icons.phone_android_outlined,
                  prefixText: '+62 ',
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                  ],
                  validator: controller.validatePhone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),

                // address
                CustomTextField(
                  label: 'Alamat',
                  hint: 'Masukkan Alamat',
                  prefixIcon: Icons.home_outlined,
                  controller: controller.addressController,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  validator: controller.validateAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 32),

                // Register button
                Obx(
                  () => CustomButton(
                    text: 'Daftar',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
