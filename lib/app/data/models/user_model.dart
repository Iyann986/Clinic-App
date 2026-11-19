/// Model user (dipakai untuk role `patient`, `doctor`, maupun `admin`).
/// Field-field khusus dokter (certification, specialization, fee, jam
/// praktik, dll) akan null kalau user-nya pasien.
///
/// Dipakai dua arah:
/// - `fromJson` -> parsing response dari REST API (login, profile, dll)
/// - `toMap` -> disimpan ke koleksi `users` di Firestore (dipakai fitur chat)
class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final String? googleId;
  final String? ktpNumber;
  final DateTime? birthDate;
  final String? gender;
  final String? phoneNumber;
  final String? address;

  /// MARK: Field khusus dokter
  final String? certification;
  final String? specialization;
  final int? telemedicineFee;
  final int? chatFee;
  final String? startTime;
  final String? endTime;
  final int? clinicId;

  final String? image;
  final String? status;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.googleId,
    this.ktpNumber,
    this.birthDate,
    this.gender,
    this.phoneNumber,
    this.address,
    this.certification,
    this.specialization,
    this.telemedicineFee,
    this.chatFee,
    this.startTime,
    this.endTime,
    this.clinicId,
    this.image,
    this.status,
  });

  bool get isDoctor => role == 'doctor';
  bool get isPatient => role == 'patient';
  bool get isAdmin => role == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    googleId: json['google_id'],
    ktpNumber: json['ktp_number'],
    birthDate: json['birth_date'] == null
        ? null
        : DateTime.tryParse(json['birth_date']),
    gender: json['gender'],
    phoneNumber: json['phone_number'],
    address: json['address'],
    certification: json['certification'],
    specialization: json['specialization'] is Map
        ? json['specialization']['name']
        : json['specialization'],
    telemedicineFee: json['telemedicine_fee'],
    chatFee: json['chat_fee'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    clinicId: json['clinic_id'],
    image: json['image'],
    status: json['status'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'google_id': googleId,
    'ktp_number': ktpNumber,
    'birth_date': birthDate == null
        ? null
        : '${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}',
    'gender': gender,
    'phone_number': phoneNumber,
    'address': address,
    'certification': certification,
    'specialization': specialization,
    'telemedicine_fee': telemedicineFee,
    'chat_fee': chatFee,
    'start_time': startTime,
    'end_time': endTime,
    'clinic_id': clinicId,
    'image': image,
    'status': status,
  };
}
