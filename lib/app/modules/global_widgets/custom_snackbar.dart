import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Snackbar custom untuk feedback singkat (sukses/error/warning/info),
/// dipakai oleh Controller & Service di seluruh aplikasi.
///
/// Usage:
///   CustomSnackbar.success('Berhasil login');
///   CustomSnackbar.error('Gagal memuat data');
class CustomSnackbar {
  CustomSnackbar._();

  static void success(String message, {String? title}) {
    _showSnackbar(
      title: title,
      message: message,
      bgColor: const Color(0xFFD4EDDA),
      iconBgColor: const Color(0xFF28A745),
      iconData: Icons.check_circle_outline_rounded,
    );
  }

  static void error(String message, {String? title}) {
    final cleanMessage = message
        .replaceAll('Exception: ', '')
        .replaceAll('Exception:', '')
        .trim();
    _showSnackbar(
      title: title,
      message: cleanMessage,
      bgColor: const Color(0xFFFAD9D9),
      iconBgColor: const Color(0xFFC93B4A),
      iconData: Icons.error_outline_rounded,
    );
  }

  static void warning(String message, {String? title}) {
    _showSnackbar(
      title: title,
      message: message,
      bgColor: const Color(0xFFFFF3CD),
      iconBgColor: const Color(0xFFFFC107),
      iconData: Icons.warning_amber_rounded,
    );
  }

  static void info(String message, {String? title}) {
    _showSnackbar(
      title: title,
      message: message,
      bgColor: const Color(0xFFD1ECF1),
      iconBgColor: const Color(0xFF17A2B8),
      iconData: Icons.info_outline_rounded,
    );
  }

  static void _showSnackbar({
    String? title,
    required String message,
    required Color bgColor,
    required Color iconBgColor,
    required IconData iconData,
  }) {
    Get.rawSnackbar(
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: EdgeInsets.zero,
      messageText: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
