import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/services/activity_service.dart';
import 'package:laci_mobile/models/activity_model.dart';

import 'package:laci_mobile/models/activity_filter_model.dart';
import 'package:laci_mobile/models/user_model.dart';
import 'package:laci_mobile/services/user_service.dart';

final filterUsersProvider = FutureProvider.autoDispose<List<UserModel>>((ref) async {
  final service = UserService();
  return service.getFilterOptions();
});

final activityFilterProvider = StateProvider.family<ActivityFilterModel, String>((ref, type) {
  return ActivityFilterModel(type: type);
});

final activityServiceProvider = Provider<ActivityService>((ref) {
  return ActivityService();
});

class ActivityNotifier extends AutoDisposeFamilyAsyncNotifier<ActivityResponse, ActivityFilterModel> {
  bool _isLoadingMore = false;

  @override
  Future<ActivityResponse> build(ActivityFilterModel arg) async {
    final service = ref.watch(activityServiceProvider);

    return service.getActivities(
      type: arg.type,
      search: arg.search,
      module: arg.module,
      action: arg.action,
      userId: arg.userId,
      page: 1,
      limit: 20,
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore) return;

    final currentState = state.value;
    if (currentState == null || !currentState.hasMore) return;

    _isLoadingMore = true;

    try {
      final service = ref.read(activityServiceProvider);
      final nextPage = currentState.page + 1;

      final response = await service.getActivities(
        type: arg.type,
        search: arg.search,
        module: arg.module,
        action: arg.action,
        userId: arg.userId,
        page: nextPage,
        limit: currentState.limit,
      );

      state = AsyncData(
        ActivityResponse(
          data: [...currentState.data, ...response.data],
          total: response.total,
          page: response.page,
          limit: response.limit,
          hasMore: response.hasMore,
          stats: response.stats,
        ),
      );
    } catch (e) {
      // Keep old state but you can handle error silently if needed
    } finally {
      _isLoadingMore = false;
    }
  }
}

final activityProvider = AsyncNotifierProvider.autoDispose.family<ActivityNotifier, ActivityResponse, ActivityFilterModel>(ActivityNotifier.new);
