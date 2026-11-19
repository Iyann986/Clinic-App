import 'package:clinic_app/app/assets/resource_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ResourcePath.splashScreenBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ResourcePath.logoSehatmuPng,
            height: 200.0,
            width: 200.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
