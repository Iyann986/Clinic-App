import 'package:intl/intl.dart';

/// Kumpulan helper format angka/teks yang dipakai lintas modul
/// (biaya konsultasi, harga, dll).
class FormatHelper {
  FormatHelper._();

  /// Format angka jadi "Rp 150.000". Terima int, double, atau String angka.
  static String formatCurrency(dynamic amount) {
    final parsed = amount is num ? amount : num.tryParse(amount.toString());
    if (parsed == null) return 'Rp 0';
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(parsed);
  }

  /// Bersihkan teks jadi angka murni, contoh "Rp 150.000" -> 150000.
  static int cleanCurrencyToNumber(String formattedText) {
    final cleaned = formattedText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
}
