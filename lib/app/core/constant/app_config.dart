/// Saklar mock/dummy data per fitur.
///
/// Dipakai selama backend/endpoint terkait belum siap, supaya UI tetap
/// bisa dites & diklik-klik dengan data dummy (bukan error/loading terus).
///
/// Begitu endpoint aslinya sudah siap & sudah dites, tinggal ganti flag
/// terkait jadi `false` — tidak perlu ubah kode di Controller/View sama
/// sekali, karena switch mock/asli sudah ditangani di level Repository.
class AppConfig {
  AppConfig._();

  /// `POST /api/login` (email & password) belum siap di backend.
  static const bool useMockLogin = true;

  /// `POST /api/login/google` belum sempurna di backend.
  static const bool useMockLoginGoogle = true;
}
