import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/routes/router_path.dart';
import 'package:taba/routes/router_provider.dart';
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
        items: [
          IconButton(
            onPressed: () {
              ref.read(pageControllerProvider).jumpToPage(0);
            },
            icon: Icon(Icons.home_outlined),
          ),
          IconButton(
            onPressed: () {
              ref.read(pageControllerProvider).jumpToPage(1);
            },
            icon: Icon(Icons.search),
          ),
          SizedBox.shrink(),
          IconButton(
            onPressed: () {
              ref.read(pageControllerProvider).jumpToPage(2);
            },
            icon: Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {
              ref.read(pageControllerProvider).jumpToPage(3);
            },
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(routerProvider).push(RouteInfo.imageRecognition.fullPath);
        },
        child: const Icon(Icons.lightbulb),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
