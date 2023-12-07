import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:taba/domain/perfume/perfume_provider.dart';
import 'package:taba/modules/orb/components/components.dart';
import 'package:taba/routes/router_provider.dart';
import 'package:taba/screen/main/home/image_recognition_screen.dart';

import '../../../routes/router_path.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();
  final int _totalAds = 3; // 총 광고 페이지 수

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PerfumeList> perfumeList = ref.watch(perfumeListProvider);
    final ThemeData theme = Theme.of(context);


    return OrbScaffold(
      orbAppBar: OrbAppBar(
        title: "PURPLE",
      ),
      shrinkWrap: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: [
              Image.asset(
                'assets/images/main_image1.png',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/images/main_image2.JPG',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/images/main_image3.JPG',
                fit: BoxFit.fill,
              ),
            ]
                .map((e) => Builder(builder: (BuildContext context) {
                      return ClipRRect(
                        //borderRadius: BorderRadius.circular(8),
                        child: e,
                      );
                    }))
                .toList(),
            options: CarouselOptions(
              clipBehavior: Clip.hardEdge,
              aspectRatio: 1.2,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(seconds: 2),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) {},
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          OrbButton(
            buttonText: '카리스에게 추천받기',
            onPressed: () async {
              ref
                  .read(routerProvider)
                  .push(RouteInfo.imageRecognition.fullPath);
            },
          ),
          const SizedBox(
            height: 16,
          ),

          OrbBoardContainer(
            titleText: 'Best Rated',
            child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: perfumeList.when(
              data: (perfumeList) => perfumeList.size,
              loading: () => 0,
              error: (error, stackTrace) => 0,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xffffffff),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0f000000),
                              offset: Offset(0, 4),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            //
                          },
                          child: Image.network(
                            perfumeList.when(
                              data: (perfumeList) =>
                                  perfumeList.content[index].thumbnailUrl!,
                              loading: () => '',
                              error: (error, stackTrace) => '',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              perfumeList.when(
                                data: (perfumeList) =>
                                    perfumeList.content[index].company,
                                loading: () => '',
                                error: (error, stackTrace) => '',
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 42,
                              child: Text(
                                perfumeList.when(
                                  data: (perfumeList) =>
                                      perfumeList.content[index].name,
                                  loading: () => '',
                                  error: (error, stackTrace) => '',
                                ),
                                style: theme.textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: IconButton(
                          onPressed: () {
                            final _perfumeList = ref.read(perfumeListProvider.notifier).favoritePerfumeList;
                            if(_perfumeList.contains(perfumeList.value!.content[index])) {
                              ref
                                  .read(perfumeListProvider.notifier)
                                  .removeFavoritePerfume(
                                perfumeList.value!.content[index],
                              );
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  '찜 목록에서 삭제되었습니다.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                                duration: const Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else{
                              ref
                                  .read(perfumeListProvider.notifier)
                                  .addFavoritePerfume(
                                perfumeList.value!.content[index],
                              );
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  '찜 목록에 추가되었습니다.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                                duration: const Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: Icon(Icons.favorite_border_outlined),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          ),
        ],
      ),
    );
  }
}
