import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityModel {
  final String id;
  final String userId;
  final String periodeId;
  final String action;
  final String module;
  final String description;
  final String? ipAddress;
  final String? userAgent;
  final String? device;
  final String? location;
  final DateTime createdAt;
  final String userName;
  final String periodeName;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.periodeId,
    required this.action,
    required this.module,
    required this.description,
    this.ipAddress,
    this.userAgent,
    this.device,
    this.location,
    required this.createdAt,
    required this.userName,
    required this.periodeName,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      periodeId: json['periodeId'] ?? '',
      action: json['action'] ?? 'UNKNOWN',
      module: json['module'] ?? '-',
      description: json['description'] ?? '-',
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
      device: json['device'],
      location: json['location'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      userName: json['user']?['name'] ?? 'Sistem',
      periodeName: json['periode']?['nama'] ?? '-',
    );
  }

  // Helper getters for UI
  Color get actionColor {
    final actionUpper = action.toUpperCase();
    if (actionUpper == 'CREATE') return Colors.green;
    if (actionUpper == 'UPDATE') return Colors.blue;
    if (actionUpper == 'DELETE') return Colors.red;
    if (actionUpper == 'LOGIN') return Colors.green;
    if (actionUpper == 'LOGOUT') return Colors.orange;
    return Colors.grey;
  }

  String get formattedDate {
    return DateFormat('d MMMM yyyy - HH.mm.ss', 'id_ID').format(createdAt);
  }

  String get formattedDateOnly {
    return DateFormat('d MMMM yyyy', 'id_ID').format(createdAt);
  }

  String get formattedTimeOnly {
    return '${DateFormat('HH.mm.ss', 'id_ID').format(createdAt)} WIB';
  }
}

class ActivityResponse {
  final List<ActivityModel> data;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;
  final Map<String, int> stats;

  ActivityResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
    required this.stats,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] ?? {};
    final rawData = json['data'] as List? ?? [];
    final limitVal = meta['limit'] as int? ?? 10;
    final totalVal = meta['total'] as int? ?? 0;
    final pageVal = meta['page'] as int? ?? 1;
    
    final Map<String, int> statsMap = {};
    if (meta['stats'] != null) {
      (meta['stats'] as Map<String, dynamic>).forEach((key, value) {
        statsMap[key] = value as int;
      });
    }

    return ActivityResponse(
      data: rawData.map((e) => ActivityModel.fromJson(e)).toList(),
      total: totalVal,
      page: pageVal,
      limit: limitVal,
      hasMore: (pageVal * limitVal) < totalVal,
      stats: statsMap,
    );
  }
}
