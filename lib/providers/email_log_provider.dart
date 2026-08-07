import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/models/email_log_model.dart';
import 'package:laci_mobile/services/email_log_service.dart';

final emailLogServiceProvider = Provider<EmailLogService>((ref) {
  return EmailLogService();
});

class EmailLogQuery {
  final int page;
  final int limit;
  final String? search;

  EmailLogQuery({
    this.page = 1,
    this.limit = 10,
    this.search,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailLogQuery &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          limit == other.limit &&
          search == other.search;

  @override
  int get hashCode => page.hashCode ^ limit.hashCode ^ search.hashCode;
}

final emailLogQueryProvider = StateProvider<EmailLogQuery>((ref) {
  return EmailLogQuery();
});

class EmailLogsNotifier extends AutoDisposeAsyncNotifier<EmailLogResponse> {
  bool _isLoadingMore = false;

  @override
  Future<EmailLogResponse> build() async {
    final service = ref.watch(emailLogServiceProvider);
    final query = ref.watch(emailLogQueryProvider);

    return service.getEmailLogs(
      page: query.page,
      limit: query.limit,
      search: query.search,
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore) return;

    final currentState = state.value;
    if (currentState == null || !currentState.hasMore) return;

    _isLoadingMore = true;

    try {
      final service = ref.read(emailLogServiceProvider);
      final query = ref.read(emailLogQueryProvider);

      final nextPage = currentState.currentPage + 1;

      final nextResponse = await service.getEmailLogs(
        page: nextPage,
        limit: query.limit,
        search: query.search,
      );

      state = AsyncData(EmailLogResponse(
        stats: currentState.stats, // Stats might update, but appending is fine
        logs: [...currentState.logs, ...nextResponse.logs],
        currentPage: nextResponse.currentPage,
        totalPages: nextResponse.totalPages,
        hasMore: nextResponse.hasMore,
      ));
    } catch (e) {
      // Ignored: keep existing state if load more fails
    } finally {
      _isLoadingMore = false;
    }
  }
}

final emailLogsProvider =
    AutoDisposeAsyncNotifierProvider<EmailLogsNotifier, EmailLogResponse>(() {
  return EmailLogsNotifier();
});
