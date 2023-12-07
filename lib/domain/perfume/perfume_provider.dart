// perfume_provider.dart
import 'dart:async';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:taba/domain/auth/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final perfumeListProvider =
AsyncNotifierProvider<PerfumeListNotifier, PerfumeList>(
        () => PerfumeListNotifier());

class PerfumeListNotifier extends AsyncNotifier<PerfumeList> {

  final List<Perfume> favoritePerfumeList = [];

  void addFavoritePerfume(Perfume perfume) {
    favoritePerfumeList.add(perfume);
  }

  void removeFavoritePerfume(Perfume perfume) {
    favoritePerfumeList.remove(perfume);
  }

  // 페이지 번호와 한 페이지당 항목 수를 매개변수로 받는 getPerfumeList 함수
  void getPerfumeList(int page, int size) async {
    state = await AsyncValue.guard(
            () => ref.read(repositoryProvider).getPerfumeList(page, size));
  }

  // build 메서드에서 첫 페이지의 데이터를 가져옵니다.
  // 이 예시에서는 첫 페이지를 0으로 가정하고, 한 페이지당 10개의 항목을 가져옵니다.
  @override
  FutureOr<PerfumeList> build() async {
    getPerfumeList(0, 10); // 첫 페이지 데이터 로드
    print('error: ${state.error}');
    return state.value!;
  }
}
