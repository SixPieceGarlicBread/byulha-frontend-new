import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:taba/domain/perfume/perfume_list_provider.dart';
import 'package:taba/modules/orb/components/components.dart';
import 'package:taba/routes/router_provider.dart';
import 'package:taba/screen/main/home/perfume_detail.dart';

import '../../../routes/router_path.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreen();
}

class _HomeScreen extends ConsumerState {
  final PageController _pageController = PageController();
  final int _totalAds = 2; // 총 광고 페이지 수

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PerfumeBoard> perfumeBoard =
        ref.watch(perfumeListProvider);
    final favoritePerfumeList = ref.watch(favoritePerfumeListProvider);
    final ThemeData theme = Theme.of(context);

    return OrbScaffold(
      orbAppBar: const OrbAppBar(
        title: "PURPLE",
        trailing: Icon(Icons.menu),
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
            buttonText: '<AI조향사 리비>에게 추천받기',
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
              itemCount: perfumeBoard.when(
                data: (perfumeList) => perfumeList.content.length,
                loading: () => 10,
                error: (error, stackTrace) => 10,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                return perfumeBoard.when(
                  data: (perfumeList) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 40,
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
                                  ref.read(routerProvider).push(
                                      RouteInfo.perfumeDetail.fullPath,
                                      extra: perfumeList.content[index].id);
                                  //
                                },
                                child: Image.network(
                                  perfumeList.content[index].thumbnailUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Column(
                              children: [
                                Text(
                                  perfumeList.content[index].company,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  perfumeList.content[index].name,
                                  style: theme.textTheme.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (favoritePerfumeList
                                      .contains(perfumeList.content[index])) {
                                    favoritePerfumeList
                                        .remove(perfumeList.content[index]);
                                  } else {
                                    favoritePerfumeList
                                        .add(perfumeList.content[index]);
                                  }
                                });
                              },
                              icon: favoritePerfumeList
                                      .contains(perfumeList.content[index])
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Color(0xff625a8b),
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      color: Color(0xff625a8b),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const OrbShimmerContent(),
                  error: (error, stackTrace) => const OrbShimmerContent(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
