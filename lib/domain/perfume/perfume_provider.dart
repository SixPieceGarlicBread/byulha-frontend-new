import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/perfume/perfume.dart';

import '../../routes/router_path.dart';
import '../../routes/router_provider.dart';
import '../repository.dart';

final perfumeProvider =
    AsyncNotifierProvider.autoDispose<PerfumeNotifier, PerfumeDetail>(() => PerfumeNotifier());

class PerfumeNotifier extends AutoDisposeAsyncNotifier<PerfumeDetail> {
  // 페이지 번호와 한 페이지당 항목 수를 매개변수로 받는 getPerfumeList 함수
  void getPerfumeDetail(int id) async {
    state = await AsyncValue.guard(
        () => ref.read(repositoryProvider).getPerfumeDetail(id));
  }

  // build 메서드에서 첫 페이지의 데이터를 가져옵니다.
  // 이 예시에서는 첫 페이지를 0으로 가정하고, 한 페이지당 10개의 항목을 가져옵니다.
  @override
  FutureOr<PerfumeDetail> build() async {
    if(state.hasValue) ref.invalidate(perfumeProvider);
    return state.value!;
  }
}
