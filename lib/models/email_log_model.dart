class EmailLogStats {
  final int today;
  final int total;
  final int sent;

  EmailLogStats({
    required this.today,
    required this.total,
    required this.sent,
  });

  factory EmailLogStats.fromJson(Map<String, dynamic> json) {
    return EmailLogStats(
      today: json['today'] ?? 0,
      total: json['total'] ?? 0,
      sent: json['sent'] ?? 0,
    );
  }
}

class EmailLog {
  final String id;
  final String to;
  final String subject;
  final String type;
  final String status;
  final String? errorMessage;
  final int retryCount;
  final DateTime createdAt;

  EmailLog({
    required this.id,
    required this.to,
    required this.subject,
    required this.type,
    required this.status,
    this.errorMessage,
    required this.retryCount,
    required this.createdAt,
  });

  factory EmailLog.fromJson(Map<String, dynamic> json) {
    return EmailLog(
      id: json['id'] ?? '',
      to: json['to'] ?? '',
      subject: json['subject'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      errorMessage: json['errorMessage'],
      retryCount: json['retryCount'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class EmailLogResponse {
  final EmailLogStats stats;
  final List<EmailLog> logs;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  EmailLogResponse({
    required this.stats,
    required this.logs,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  factory EmailLogResponse.fromJson(Map<String, dynamic> json) {
    var logsList = json['logs'] as List? ?? [];
    List<EmailLog> logs = logsList.map((i) => EmailLog.fromJson(i)).toList();

    final pagination = json['pagination'] ?? {};
    final currentPage = pagination['page'] ?? 1;
    final totalPages = pagination['totalPages'] ?? 1;
    
    return EmailLogResponse(
      stats: EmailLogStats.fromJson(json['stats'] ?? {}),
      logs: logs,
      currentPage: currentPage,
      totalPages: totalPages,
      hasMore: currentPage < totalPages,
    );
  }
}
