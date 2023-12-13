import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/screen/main/home/home_screen.dart';
import 'package:taba/screen/main/profile_screen.dart';
import 'package:taba/screen/main/search_screen.dart';
import '../../modules/orb/components/components.dart';
import 'favorite_screen.dart';
import 'home/image_recognition_screen.dart'; // Orb 스킨 컴포넌트

final pageControllerProvider = StateProvider<PageController>((ref) {
  return PageController(initialPage: 0);
});

final _currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: ref.watch(pageControllerProvider),
        onPageChanged: (value) {
          ref.read(_currentIndexProvider.notifier).update((state) => value);
        },

        children: [
          const HomeScreen(), // 홈 화면
          const SearchScreen(), // 검색 화면
          const FavoriteScreen(), // 찜 목록 화면
          const ProfileScreen() // 프로필 화면

          // 다른 화면들도 여기에 추가
        ],
      ),
      bottomNavigationBar: OrbBottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "검색"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "찜 목록"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "내 정보"),
        ],
        onIndexChanged: (value) {
          ref.read(pageControllerProvider).jumpToPage(value);
        },
        currentIndex: ref.watch(_currentIndexProvider),
      ),
    );
  }
}
