import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/models/periode_model.dart';
import 'package:laci_mobile/services/periode_service.dart';

final periodeServiceProvider = Provider<PeriodeService>((ref) {
  return PeriodeService();
});

// Provider utama: daftar semua periode
final periodesProvider = AutoDisposeAsyncNotifierProvider<PeriodesNotifier, List<Periode>>(() {
  return PeriodesNotifier();
});

class PeriodesNotifier extends AutoDisposeAsyncNotifier<List<Periode>> {
  @override
  Future<List<Periode>> build() async {
    final service = ref.watch(periodeServiceProvider);
    return service.getPeriodes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(periodeServiceProvider).getPeriodes());
  }

  Future<String?> create(String nama) async {
    try {
      await ref.read(periodeServiceProvider).createPeriode(nama);
      await refresh();
      return null; // null berarti sukses
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<String?> updatePeriode(String id, String nama) async {
    try {
      await ref.read(periodeServiceProvider).updatePeriode(id, nama);
      await refresh();
      return null;
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<bool> activate(String id) async {
    try {
      await ref.read(periodeServiceProvider).activatePeriode(id);
      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await ref.read(periodeServiceProvider).deletePeriode(id);
      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Provider untuk menyimpan periode mana yang sedang "dilihat" (viewed) di Home
final viewedPeriodeProvider = StateProvider<Periode?>((ref) {
  return null; // null berarti mengikuti yang aktif
});
