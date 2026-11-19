/// Wrapper generic untuk semua response API backend Ayo Sehat.
///
/// Bentuk asli response backend (Laravel) selalu:
/// ```json
/// { "status": "success", "data": { ... } }
/// ```
/// atau saat error:
/// ```json
/// { "message": "Pesan error di sini" }
/// ```
///
/// NOTE: field `status` di backend kadang berupa String ("success"),
/// kadang int/bool tergantung endpoint — makanya di sini disimpan sebagai
/// String? hasil `.toString()` agar tidak crash. Untuk cek sukses/gagal,
/// andalkan HTTP status code (sudah ditangani di `ApiService`), bukan
/// field `status` ini.
///
/// Usage:
/// ```dart
/// final response = await apiService.post(ApiConstant.auth.login, body: body);
/// return ResponseModel<LoginModel>.fromJson(
///   response,
///   (json) => LoginModel.fromJson(json),
/// );
/// ```
class ResponseModel<T> {
  final String? status;
  final String? message;
  final T? data;

  ResponseModel({this.status, this.message, this.data});

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ResponseModel<T>(
      status: json['status']?.toString(),
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
