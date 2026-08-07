class ActivityFilterModel {
  final String type; // 'personal' or 'global'
  final String? search;
  final String? module;
  final String? action;
  final String? userId;

  ActivityFilterModel({
    required this.type,
    this.search,
    this.module,
    this.action,
    this.userId,
  });

  ActivityFilterModel copyWith({
    String? type,
    String? search,
    String? module,
    String? action,
    String? userId,
  }) {
    return ActivityFilterModel(
      type: type ?? this.type,
      search: search ?? this.search,
      module: module ?? this.module,
      action: action ?? this.action,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityFilterModel &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          search == other.search &&
          module == other.module &&
          action == other.action &&
          userId == other.userId;

  @override
  int get hashCode =>
      type.hashCode ^
      search.hashCode ^
      module.hashCode ^
      action.hashCode ^
      userId.hashCode;
}
