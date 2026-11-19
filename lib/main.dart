import 'package:clinic_app/app/core/theme/app_theme.dart';
import 'package:clinic_app/app/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // TODO: Setup Firebase & OneSignal sebelum build fitur Chat/Notifikasi.
  // 1. Jalankan `flutterfire configure` di root project supaya file
  //    `firebase_options.dart` ter-generate otomatis (jangan pakai
  //    kredensial project Firebase orang lain).
  // 2. Baru aktifkan baris berikut:
  //
  //    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //    OneSignal.initialize('<APP_ID_ONESIGNAL_MILIK_SENDIRI>');
  //    OneSignal.Notifications.requestPermission(true);

  // Daftarkan service inti sebagai permanent agar bisa diakses
  // lewat Get.find<T>() dari repository mana pun sepanjang aplikasi berjalan.
  Get.put<ApiService>(ApiService(), permanent: true);

  runApp(
    GetMaterialApp(
      title: 'Ayo Sehat',
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      locale: const Locale('id', 'ID'),
    ),
  );
}
