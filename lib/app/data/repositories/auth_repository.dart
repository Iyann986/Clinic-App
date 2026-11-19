import 'package:clinic_app/app/core/constant/api.dart';
import 'package:clinic_app/app/core/constant/app_config.dart';
import 'package:clinic_app/app/core/constant/storage.dart';
import 'package:clinic_app/app/data/models/login_model.dart';
import 'package:clinic_app/app/data/models/register_model.dart';
import 'package:clinic_app/app/data/models/response_model.dart';
import 'package:clinic_app/app/data/models/user_model.dart';
import 'package:clinic_app/app/data/services/api_service.dart';
import 'package:clinic_app/app/data/services/local_service.dart';
import 'package:get/get.dart';

/// Repository untuk semua yang berhubungan dengan autentikasi (login,
/// login Google, logout). Controller tidak pernah panggil ApiService
/// langsung — selalu lewat repository seperti ini.
///
/// NOTE: `login()` & `loginGoogle()` sementara masih pakai DATA DUMMY
/// (lihat `AppConfig.useMockLogin` / `useMockLoginGoogle`) karena
/// endpoint backend-nya belum siap/belum sempurna. Kode pemanggilan API
/// aslinya sudah ditulis lengkap di bawah, tinggal di-nonaktifkan
/// flag-nya di `AppConfig` begitu backend siap — tidak perlu ubah kode
/// apa pun di Controller/View.
class AuthRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final LocalService _localService = LocalService();

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    if (AppConfig.useMockLogin) {
      return _mockLogin(email: email);
    }

    try {
      final response = await _apiService.post(
        ApiConstant.auth.login,
        body: {'email': email, 'password': password},
        requireAuth: false,
      );

      final result = ResponseModel<LoginModel>.fromJson(
        response,
        (json) => LoginModel.fromJson(json),
      );

      final loginData = result.data;
      if (loginData?.token == null) {
        throw Exception('Token tidak ditemukan pada response.');
      }

      await _localService.write(StorageKey.tokenAccess, loginData!.token!);
      return loginData;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginModel> loginGoogle(String idToken) async {
    if (AppConfig.useMockLoginGoogle) {
      return _mockLogin(email: 'user.google@gmail.com', viaGoogle: true);
    }

    try {
      final response = await _apiService.post(
        ApiConstant.auth.loginGoogle,
        body: {'id_token': idToken},
        requireAuth: false,
      );

      final result = ResponseModel<LoginModel>.fromJson(
        response,
        (json) => LoginModel.fromJson(json),
      );

      final loginData = result.data;
      if (loginData?.token == null) {
        throw Exception('Token tidak ditemukan pada response.');
      }

      await _localService.write(StorageKey.tokenAccess, loginData!.token!);
      return loginData;
    } catch (e) {
      rethrow;
    }
  }

  Future<RegisterModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String birthDate,
    required String gender,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstant.auth.register,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'birth_date': birthDate,
          'gender': gender,
          'phone_number': phoneNumber,
          'address': address,
        },
        requireAuth: false,
      );

      final result = ResponseModel<RegisterModel>.fromJson(
        response,
        (json) => RegisterModel.fromJson(json),
      );

      final registerData = result.data;
      if (registerData?.accessToken == null) {
        throw Exception('Registrasi gagal, silakan coba lagi.');
      }

      await _localService.write(
        StorageKey.tokenAccess,
        registerData!.accessToken!,
      );
      if (registerData.refreshToken != null) {
        await _localService.write(
          StorageKey.tokenRefresh,
          registerData.refreshToken!,
        );
      }

      return registerData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    if (AppConfig.useMockLogin) {
      await _localService.clearAll();
      return;
    }

    try {
      await _apiService.post(ApiConstant.auth.logout);
    } catch (_) {
      // Abaikan error dari server (mis. token sudah expired) — tetap
      // hapus sesi lokal di bawah supaya user pasti ter-logout di app.
    } finally {
      await _localService.clearAll();
    }
  }

  /// Simulasi login: delay kecil (biar terasa seperti hit API beneran)
  /// lalu kembalikan data dummy & simpan dummy token ke local storage.
  Future<LoginModel> _mockLogin({
    required String email,
    bool viaGoogle = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final dummyUser = UserModel(
      id: 1,
      name: viaGoogle ? 'Budi Santoso (Google)' : 'Budi Santoso',
      email: email,
      role: 'patient',
      phoneNumber: '081234567890',
      address: 'Jl. Merdeka No. 10, Jakarta Pusat',
      gender: 'Laki-laki',
      image: null,
      status: 'active',
    );

    final dummyResult = LoginModel(
      token: 'dummy-token-${DateTime.now().millisecondsSinceEpoch}',
      isNew: false,
      user: dummyUser,
    );

    await _localService.write(StorageKey.tokenAccess, dummyResult.token!);
    return dummyResult;
  }
}
