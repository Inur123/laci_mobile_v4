class Periode {
  final String id;
  final String nama;
  final bool isActive;
  final DateTime createdAt;
  final int anggotaCount;
  final int arsipSuratCount;
  final int agendaCount;
  final int presensiCount;

  Periode({
    required this.id,
    required this.nama,
    required this.isActive,
    required this.createdAt,
    this.anggotaCount = 0,
    this.arsipSuratCount = 0,
    this.agendaCount = 0,
    this.presensiCount = 0,
  });

  factory Periode.fromJson(Map<String, dynamic> json) {
    final counts = json['_count'] as Map<String, dynamic>? ?? {};
    return Periode(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      anggotaCount: counts['anggota'] ?? 0,
      arsipSuratCount: counts['arsipSurats'] ?? 0,
      agendaCount: counts['agendaKegiatan'] ?? 0,
      presensiCount: counts['presensi'] ?? 0,
    );
  }
}
