class TopPacModel {
  final String name;
  final int totalAnggota;
  final int totalArsipSurat;

  TopPacModel({
    required this.name,
    required this.totalAnggota,
    required this.totalArsipSurat,
  });

  factory TopPacModel.fromJson(Map<String, dynamic> json) {
    return TopPacModel(
      name: json['name'] ?? '',
      totalAnggota: json['totalAnggota'] ?? 0,
      totalArsipSurat: json['totalArsipSurat'] ?? 0,
    );
  }
}

class DashboardMonitoringModel {
  final int totalAnggota;
  final int totalAdministrasi;
  final int pacAktif;
  final int pacVerif;
  final int pacPending;
  final List<TopPacModel> topPacs;

  DashboardMonitoringModel({
    required this.totalAnggota,
    required this.totalAdministrasi,
    required this.pacAktif,
    required this.pacVerif,
    required this.pacPending,
    required this.topPacs,
  });

  factory DashboardMonitoringModel.fromJson(Map<String, dynamic> json) {
    var topPacsJson = json['topPacs'] as List? ?? [];
    List<TopPacModel> topPacsList = topPacsJson.map((i) => TopPacModel.fromJson(i)).toList();

    return DashboardMonitoringModel(
      totalAnggota: json['totalAnggota'] ?? 0,
      totalAdministrasi: json['totalAdministrasi'] ?? 0,
      pacAktif: json['pacAktif'] ?? 0,
      pacVerif: json['pacVerif'] ?? 0,
      pacPending: json['pacPending'] ?? 0,
      topPacs: topPacsList,
    );
  }
}
