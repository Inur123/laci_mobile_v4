class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final bool emailVerified;
  final String? image;
  final String? periodeAktifId;
  final String? periodeAktifName;
  final DateTime? createdAt;
  final DateTime? lastLogoutAt;

  UserModel({
    required this.id,
    required this.name,
    this.email = '',
    required this.role,
    this.isActive = false,
    this.emailVerified = false,
    this.image,
    this.periodeAktifId,
    this.periodeAktifName,
    this.createdAt,
    this.lastLogoutAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      image: json['image'],
      periodeAktifId: json['periodeAktifId'],
      periodeAktifName: json['periodeAktifName'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      lastLogoutAt: json['lastLogoutAt'] != null ? DateTime.tryParse(json['lastLogoutAt']) : null,
    );
  }
}

class UserDetailModel {
  final UserModel user;
  final Map<String, int> statsAktivitas;
  final List<Map<String, dynamic>> statsPendidikan;
  final List<Map<String, dynamic>> statsPengkaderan;

  UserDetailModel({
    required this.user,
    required this.statsAktivitas,
    required this.statsPendidikan,
    required this.statsPengkaderan,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      user: UserModel.fromJson(json['user'] ?? {}),
      statsAktivitas: Map<String, int>.from(json['statsAktivitas'] ?? {}),
      statsPendidikan: List<Map<String, dynamic>>.from(json['statsPendidikan'] ?? []),
      statsPengkaderan: List<Map<String, dynamic>>.from(json['statsPengkaderan'] ?? []),
    );
  }
}

class UserStatsModel {
  final int totalUser;
  final int akunAktif;
  final int akunNonaktif;

  UserStatsModel({
    required this.totalUser,
    required this.akunAktif,
    required this.akunNonaktif,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalUser: json['totalUser'] ?? 0,
      akunAktif: json['akunAktif'] ?? 0,
      akunNonaktif: json['akunNonaktif'] ?? 0,
    );
  }
}
