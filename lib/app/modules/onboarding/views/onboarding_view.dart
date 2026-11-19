import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinic_app/app/core/constant/colors.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: CarouselSlider.builder(
              carouselController: controller.carouselController,
              itemCount: controller.onboardingItems.length,
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: false,
                enableInfiniteScroll: false,
                onPageChanged: controller.onPageChanged,
              ),
              itemBuilder: (context, index, realIndex) {
                final item = controller.onboardingItems[index];
                return _buildSlideItem(context, item);
              },
            ),
          ),

          Positioned(
            bottom: (screenHeight * 0.4),
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.onboardingItems.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentIndex.value == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentIndex.value == index
                          ? Colors.blue[900]
                          : Colors.grey[300], // Warna abu-abu saat pasif
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Obx(() {
              final isLastPage =
                  controller.currentIndex.value ==
                  controller.onboardingItems.length - 1;
              return CustomButton(
                text: isLastPage ? 'Mulai' : 'Selanjutnya',
                borderRadius: 8.0,
                onPressed: isLastPage ? controller.start : controller.nextPage,
                backgroundColor: AppColors.primary,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideItem(BuildContext context, OnboardingModel item) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            color: const Color(0xFF127EE1),
            child: ClipRect(
              child: Image.asset(
                item.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
