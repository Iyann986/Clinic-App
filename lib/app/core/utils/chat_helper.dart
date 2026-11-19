/// Helper kecil untuk fitur chat (Firestore).
class ChatHelper {
  ChatHelper._();

  /// Bikin channel ID yang konsisten untuk satu pasang pasien-dokter di
  /// tanggal konsultasi tertentu, tidak peduli urutan id mana yang duluan
  /// dipanggil (pasien atau dokter yang generate, hasilnya tetap sama).
  static String generateChannelId(String id1, String id2, DateTime orderDate) {
    final formattedDate =
        '${orderDate.year}${orderDate.month.toString().padLeft(2, '0')}${orderDate.day.toString().padLeft(2, '0')}';
    if (id1.hashCode < id2.hashCode) {
      return '$id1-$id2-$formattedDate';
    }
    return '$id2-$id1-$formattedDate';
  }
}
