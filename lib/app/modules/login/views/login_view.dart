import 'package:clinic_app/app/assets/resource_path.dart';
import 'package:clinic_app/app/core/constant/colors.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_button.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_textfield.dart';
import 'package:clinic_app/app/modules/global_widgets/google_signin_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                const SizedBox(height: 36),

                const Text(
                  'Selamat Datang!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Masuk untuk melanjutkan ke Sehatmu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.lightGray),
                ),
                const SizedBox(height: 32),

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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.goToForgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Lupa kata sandi?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Obx(
                  () => CustomButton(
                    text: 'Masuk',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.gray)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'atau',
                        style: TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.gray)),
                  ],
                ),
                const SizedBox(height: 24),

                Obx(
                  () => GoogleSigninButton(
                    isLoading: controller.isGoogleLoading.value,
                    onPressed: controller.loginWithGoogle,
                  ),
                ),
                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: Text(
                        'Daftar',
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
