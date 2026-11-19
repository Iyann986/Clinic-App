import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clinic_app/app/core/constant/storage.dart';

/// Pembungkus `flutter_secure_storage` agar akses local storage
/// konsisten di seluruh aplikasi (repository/controller cukup panggil
/// method di sini, tidak langsung import flutter_secure_storage).
class LocalService {
  final _box = const FlutterSecureStorage();

  Future<String?> read(String key) {
    return _box.read(key: key);
  }

  Future<void> write(String key, String value) async {
    await _box.write(key: key, value: value);
  }

  Future<void> remove(String key) async {
    await _box.delete(key: key);
  }

  /// Hapus semua data, kecuali flag `firstTimeLaunch` supaya
  /// onboarding tidak muncul lagi setelah user logout.
  Future<void> clearAll() async {
    final firstTimeLaunch = await read(StorageKey.firstTimeLaunch);
    await _box.deleteAll();
    if (firstTimeLaunch != null) {
      await write(StorageKey.firstTimeLaunch, firstTimeLaunch);
    }
  }
}
