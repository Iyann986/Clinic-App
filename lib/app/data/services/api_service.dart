import 'dart:convert';
import 'dart:io';

import 'package:clinic_app/app/core/constant/api.dart';
import 'package:clinic_app/app/core/constant/delay.dart';
import 'package:clinic_app/app/core/constant/storage.dart';
import 'package:clinic_app/app/data/services/local_service.dart';
import 'package:clinic_app/app/modules/global_widgets/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

enum HttpMethod { get, post, put, patch, delete }

/// Service pusat untuk semua komunikasi HTTP ke backend.
///
/// Didaftarkan sebagai `GetxService` permanent di `main.dart`, lalu dipakai
/// oleh repository lewat `Get.find<ApiService>()`. Menangani:
/// - Header standar (Content-Type, Authorization)
/// - Auto logout begitu dapat 401 (backend pakai token Sanctum tunggal,
///   TIDAK ada endpoint refresh — jadi 401 = sesi berakhir, titik)
/// - Logging request/response (khusus mode debug)
class ApiService extends GetxService {
  final LocalService _localService = LocalService();

  bool _isLoggedOut = false;

  Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await _localService.read(StorageKey.tokenAccess);
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> _request(
    HttpMethod method,
    String endpoint, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    bool requireAuth = true,
  }) async {
    if (_isLoggedOut) {
      _isLoggedOut = false;
      throw Exception('SESSION_ENDED');
    }

    Uri url = Uri.parse('${ApiConstant.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    final startTime = DateTime.now();

    if (queryParameters != null && queryParameters.isNotEmpty) {
      url = url.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }

    try {
      http.Response response;
      final encodedBody = body != null ? json.encode(body) : null;

      switch (method) {
        case HttpMethod.get:
          response = await http
              .get(url, headers: headers)
              .timeout(DelayConstants.timeout);
          break;
        case HttpMethod.post:
          response = await http
              .post(url, headers: headers, body: encodedBody)
              .timeout(DelayConstants.timeout);
          break;
        case HttpMethod.put:
          response = await http
              .put(url, headers: headers, body: encodedBody)
              .timeout(DelayConstants.timeout);
          break;
        case HttpMethod.patch:
          response = await http
              .patch(url, headers: headers, body: encodedBody)
              .timeout(DelayConstants.timeout);
          break;
        case HttpMethod.delete:
          response = await http
              .delete(url, headers: headers)
              .timeout(DelayConstants.timeout);
          break;
      }

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logRequest(
          method,
          endpoint,
          duration,
          body,
          response.body,
          response.statusCode,
        );
        return response.body.isEmpty ? null : json.decode(response.body);
      }

      if (response.statusCode == 401 && requireAuth) {
        _log('🚨 401 UNAUTHORIZED on $endpoint. Forcing logout...');
        _forceLogout('Sesi Anda telah berakhir, harap login ulang.');
        throw Exception('SESSION_ENDED');
      }

      throw _processError(
        response,
        method: method,
        endpoint: endpoint,
        duration: duration,
      );
    } catch (e) {
      if (e.toString() != 'Exception: SESSION_ENDED') {
        _log('API CRASH: $endpoint | $e');
      }
      rethrow;
    }
  }

  void _forceLogout(String message) {
    if (_isLoggedOut) return;
    _isLoggedOut = true;
    _localService.clearAll();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (Get.currentRoute != '/login') {
        CustomSnackbar.error(message);
        Get.offAllNamed('/login');
      }
    });
  }

  /// Reset flag logout, dipanggil setelah user berhasil login ulang.
  void resetSession() {
    _isLoggedOut = false;
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[ApiService] $message');
  }

  void _logRequest(
    HttpMethod method,
    String endpoint,
    int duration,
    Object? req,
    String res,
    int code,
  ) {
    _log(
      '[${method.name.toUpperCase()}] $endpoint (Code: $code)\n'
      '⏱️ Time : ${duration}ms\n'
      '📤 REQ  : ${req != null ? json.encode(req) : '-'}\n'
      '📥 RES  : $res',
    );
  }

  Exception _processError(
    http.Response response, {
    required HttpMethod method,
    required String endpoint,
    required int duration,
  }) {
    String errorMessage = 'Terjadi kesalahan yang tidak terduga.';
    try {
      final bodyData = json.decode(response.body);
      errorMessage = bodyData['message'] ?? errorMessage;
    } catch (_) {}

    _log(
      '[${method.name.toUpperCase()}] $endpoint (Code: ${response.statusCode})\n'
      '⏱️ Time : ${duration}ms\n'
      '📥 RES  : ${response.body}\n'
      '🚨 MSG  : $errorMessage',
    );

    return Exception(errorMessage);
  }

  // ── Public API ─────────────────────────────────────────────────────────

  Future<dynamic> get(
    String url, {
    bool requireAuth = true,
    Map<String, dynamic>? queryParameters,
  }) => _request(
    HttpMethod.get,
    url,
    requireAuth: requireAuth,
    queryParameters: queryParameters,
  );

  Future<dynamic> post(String url, {Object? body, bool requireAuth = true}) =>
      _request(HttpMethod.post, url, body: body, requireAuth: requireAuth);

  Future<dynamic> put(String url, {Object? body, bool requireAuth = true}) =>
      _request(HttpMethod.put, url, body: body, requireAuth: requireAuth);

  Future<dynamic> patch(String url, {Object? body, bool requireAuth = true}) =>
      _request(HttpMethod.patch, url, body: body, requireAuth: requireAuth);

  Future<dynamic> delete(String url, {bool requireAuth = true}) =>
      _request(HttpMethod.delete, url, requireAuth: requireAuth);

  /// Upload file (contoh: foto profil dokter) via multipart form-data.
  Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, String> files,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstant.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url);

    final headers = await _getHeaders(requireAuth: requireAuth);
    headers.remove('Content-Type'); // Biarkan http yang set boundary
    request.headers.addAll(headers);

    request.fields.addAll(fields);

    for (final entry in files.entries) {
      final filePath = entry.value;
      if (filePath.isEmpty) continue;

      final file = File(filePath);
      if (!await file.exists()) {
        _log('postMultipart file missing: field=${entry.key}, path=$filePath');
        continue;
      }

      final fileName = p.basename(filePath);
      final ext = p.extension(fileName).toLowerCase();

      MediaType contentType;
      if (ext == '.png') {
        contentType = MediaType('image', 'png');
      } else if (ext == '.webp') {
        contentType = MediaType('image', 'webp');
      } else {
        contentType = MediaType('image', 'jpeg');
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          entry.key,
          filePath,
          filename: fileName,
          contentType: contentType,
        ),
      );
    }

    final startTime = DateTime.now();
    try {
      final streamedResponse = await request.send().timeout(
        DelayConstants.timeout,
      );
      final response = await http.Response.fromStream(streamedResponse);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logRequest(
          HttpMethod.post,
          endpoint,
          duration,
          fields,
          response.body,
          response.statusCode,
        );
        return response.body.isEmpty ? null : json.decode(response.body);
      }

      throw _processError(
        response,
        method: HttpMethod.post,
        endpoint: endpoint,
        duration: duration,
      );
    } catch (e) {
      _log('API CRASH MULTIPART: $endpoint | $e');
      rethrow;
    }
  }
}
