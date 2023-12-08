// perfume_list_provider.dart
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:taba/domain/perfume/perfume_provider.dart';
import 'package:taba/domain/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routes/router_path.dart';
import '../../routes/router_provider.dart';

final recommendedPerfumeListProvider =
    AsyncNotifierProvider<RecommendedPerfumeListNotifier, PerfumeList>(
        () => RecommendedPerfumeListNotifier());

class RecommendedPerfumeListNotifier extends AsyncNotifier<PerfumeList> {
  // 페이지 번호와 한 페이지당 항목 수를 매개변수로 받는 getPerfumeList 함수
  void getPerfumeList(List<XFile> images) async {
    state = await AsyncValue.guard(
        () => ref.read(repositoryProvider).getRecommendedPerfumeList(images));
    ref
        .read(routerProvider)
        .pushReplacement(RouteInfo.recommendResult.fullPath);
  }

  // build 메서드에서 첫 페이지의 데이터를 가져옵니다.
  // 이 예시에서는 첫 페이지를 0으로 가정하고, 한 페이지당 10개의 항목을 가져옵니다.
  @override
  FutureOr<PerfumeList> build() async {
    return state.value!;
  }
}

final favoritePerfumeListProvider = StateProvider<List<Perfume>>((ref) => []);

final perfumeListProvider =
    AsyncNotifierProvider<PerfumeListNotifier, PerfumeList>(
        () => PerfumeListNotifier());

class PerfumeListNotifier extends AsyncNotifier<PerfumeList> {
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
    /*
    state = AsyncValue.data(PerfumeList(
      content: [
        Perfume(
          id: 1,
          name: '향수1',
          company: '향수회사1',
          rating: 4.5,
          forGender: '여성',
          thumbnailUrl: 'https://picsum.photos/400/400',
        ),
        Perfume(
          id: 2,
          name: '향수2향수2향수2향수2향수2',
          company: '향수회사2향수회사2향수회사2향수회사2향수회사2향수회사2향수회사2',
          rating: 4.5,
          forGender: '여성',
          thumbnailUrl: 'https://picsum.photos/400/400',
        ),
        Perfume(
          id: 3,
          name: '향수3',
          company: '향수회사3',
          rating: 4.5,
          forGender: '여성',
          thumbnailUrl: 'https://picsum.photos/400/400',
        ),
        Perfume(
          id: 4,
          name: '향수4',
          company: '향수회사4',
          rating: 4.5,
          forGender: '여성',
          thumbnailUrl: 'https://picsum.photos/400/400',
        ),
      ],
      hasNext: false,
      totalPages: 1,
      totalElements: 4,
      page: 1,
      size: 1,
      first: true,
      last: false,
    ));
     */
    return state.value!;
  }
}
