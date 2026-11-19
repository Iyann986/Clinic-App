import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Overlay loading full-screen yang bisa dipanggil dari mana saja
/// (biasanya dari Controller saat memanggil API), tanpa perlu BuildContext.
///
/// Usage:
///   LoadingHelper.show();
///   ... await someApiCall();
///   LoadingHelper.hide();
class LoadingHelper {
  LoadingHelper._();

  static OverlayEntry? _overlayEntry;

  static void show() {
    if (_overlayEntry != null) return;

    final context = Get.overlayContext ?? Get.context ?? Get.key.currentContext;

    OverlayState? overlayState;
    if (context != null) {
      overlayState = Overlay.maybeOf(context, rootOverlay: true);
    }
    overlayState ??= Get.key.currentState?.overlay;

    if (overlayState == null) return;

    final theme = context != null ? Theme.of(context) : Get.theme;

    _overlayEntry = OverlayEntry(
      builder: (context) => PopScope(
        canPop: false,
        child: Material(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Colors.white.withOpacity(0.7),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: theme.primaryColor),
                      const SizedBox(height: 20),
                      Text(
                        'Loading',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  static void hide() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (_) {}
      _overlayEntry = null;
    }
  }
}
