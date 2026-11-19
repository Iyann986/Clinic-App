/// Kumpulan base URL & endpoint API aplikasi Ayo Sehat.
///
/// Endpoint di bawah ini diambil dari backend Laravel yang sudah nyata
/// dipakai (bukan tebakan) — hasil porting dari project BLoC
/// `fic21-clinic-mobile`. Beberapa catatan penting:
///
/// - Backend TIDAK memakai prefix versi (`/api/v1`), semua endpoint
///   langsung di bawah `/api/...`.
/// - Auth pakai token Bearer tunggal (Laravel Sanctum), TIDAK ada
///   endpoint refresh token — begitu 401, ApiService langsung
///   force-logout (lihat `ApiService`).
/// - `baseUrl` di bawah masih contoh alamat dev lokal punya tim asal.
///   GANTI dengan base URL backend milik kamu sendiri sebelum dipakai.
class ApiConstant {
  ApiConstant._();

  // DEV — ganti sesuai alamat backend lokal/staging kamu
  static const String baseUrl = 'http://192.168.100.21:8000';

  // PROD
  // static const String baseUrl = 'https://api.ayosehat.co.id';

  static const auth = _Auth();
  static const user = _User();
  static const doctor = _Doctor();
  static const specialization = _Specialization();
  static const clinic = _Clinic();
  static const order = _Order();
  static const agora = _Agora();
}

class _Auth {
  const _Auth();
  final String login = '/api/login';
  final String loginGoogle = '/api/login/google';
  final String register = '/api/register';
  final String logout = '/api/logout';

  /// Kirim OneSignal player id supaya user bisa menerima push notif.
  /// Contoh: `PUT /api/update-token/{userId}`
  final String updateOneSignalToken = '/api/update-token';
}

class _User {
  const _User();
  final String check = '/api/user/check';
  final String create = '/api/user';

  /// Contoh: `GET /api/user/{email}`
  final String byEmail = '/api/user';

  /// Contoh: `PUT /api/user/google-id/{id}`
  final String updateGoogleId = '/api/user/google-id';

  /// Contoh: `PUT /api/user/{id}`
  final String update = '/api/user';
}

class _Doctor {
  const _Doctor();
  final String list = '/api/doctors';

  /// Dokter yang lagi jam praktik (dipakai untuk halaman chat).
  final String active = '/api/doctors/active';
}

class _Specialization {
  const _Specialization();
  final String list = '/api/specialists';
}

class _Clinic {
  const _Clinic();

  /// Contoh: `GET /api/clinic/{clinicId}`
  final String detail = '/api/clinic';
}

class _Order {
  const _Order();
  final String create = '/api/orders';

  /// Contoh: `GET /api/orders/patient/{patientId}`
  final String byPatient = '/api/orders/patient';

  /// Contoh: `GET /api/orders/doctor/{doctorId}`
  final String byDoctor = '/api/orders/doctor';

  /// Contoh: `GET /api/orders/clinic/{clinicId}`
  final String byClinic = '/api/orders/clinic';

  /// Webhook status pembayaran Xendit.
  /// NOTE: idealnya ini dipanggil server-to-server oleh Xendit, bukan dari
  /// mobile app — kalau dipakai untuk cek status manual, jangan simpan
  /// callback token di client, verifikasi lewat backend saja.
  final String xenditCallback = '/api/xendit-callback';
}

class _Agora {
  const _Agora();
  final String calls = '/api/agora-calls';
  final String addCall = '/api/agora-call';

  /// Contoh: `GET /api/agora/token/{channelName}`
  final String token = '/api/agora/token';
}
