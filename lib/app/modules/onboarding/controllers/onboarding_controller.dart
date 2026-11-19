import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:clinic_app/app/assets/resource_path.dart';
import 'package:clinic_app/app/core/constant/storage.dart';
import 'package:clinic_app/app/data/services/local_service.dart';
import 'package:clinic_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  /// Ikon badge kecil yang melayang di atas gambar (opsional).
  final IconData? accessoryIcon;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
    this.accessoryIcon,
  });
}

class OnboardingController extends GetxController {
  final LocalService _localService = LocalService();

  final CarouselSliderController carouselController =
      CarouselSliderController();
  var currentIndex = 0.obs;

  final List<OnboardingModel> onboardingItems = [
    OnboardingModel(
      image: ResourcePath.onboarding1Png,
      title: 'Konsultasi Kesehatan\nLebih Mudah',
      description:
          'Dapatkan layanan konsultasi dengan dokter profesional kapan saja dan di mana saja.',
    ),
    OnboardingModel(
      image: ResourcePath.onboarding2Png,
      title: 'Solusi Kesehatan\nUntuk Anda',
      description:
          'Berbagai layanan kesehatan mulai dari konsultasi, resep obat, hingga booking klinik.',
      accessoryIcon: Icons.chat_bubble_outline_rounded,
    ),
    OnboardingModel(
      image: ResourcePath.onboarding3Png,
      title: 'Data Aman,\nLayanan Terpercaya',
      description:
          'Kami menjaga data Anda dengan aman dan memberikan layanan terbaik untuk kesehatan Anda.',
      accessoryIcon: Icons.shield_outlined,
    ),
  ];

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < onboardingItems.length - 1) {
      carouselController.nextPage();
    } else {
      start();
    }
  }

  /// Tombol "Lewati" -> langsung skip ke Login tanpa menghabiskan slide.
  void skip() => start();

  void start() {
    _localService.write(StorageKey.firstTimeLaunch, 'true');
    Get.offAllNamed(Routes.LOGIN);
  }
}
