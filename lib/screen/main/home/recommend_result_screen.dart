//image_recognition_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/modules/orb/components/components.dart';
import 'package:taba/routes/router_path.dart';
import 'package:taba/routes/router_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/perfume/perfume.dart';
import '../../../domain/perfume/perfume_list_provider.dart';
import '../../../domain/perfume/perfume_provider.dart';

enum MoodType {
  androgynous(
      'androgynous', '중성적임', '오늘의 당신은 중성적이군요!\n\n중성적인 당신에게 추천하는 향수는\n.\n.\n.'),
  casual('casual', '캐주얼', '오늘의 당신은 캐주얼하군요!\n\n캐주얼한 당신에게 추천하는 향수는\n.\n.\n.'),
  cute('cute', '귀여움', '오늘의 당신은 귀엽군요!\n귀여운 당신에게 추천하는 향수는...'),
  elegant('elegant', '우아함', '오늘의 당신은 우아하군요!\n우아한 당신에게 추천하는 향수는...'),
  innocent('innocent', '순수함', '오늘의 당신은 순수하군요!\n순수한 당신에게 추천하는 향수는...'),
  manly('manly', '남성적임', '오늘의 당신은 남성적이군요!\n남성적인 당신에게 추천하는 향수는...'),
  profound('profound', '중후함', '오늘의 당신은 중후하군요!\n중후한 당신에게 추천하는 향수는...'),
  sensual('sensual', '감각적', '오늘의 당신은 감각적이군요!\n감각적인 당신에게 추천하는 향수는...'),
  sexy('sexy', '섹시함', '오늘의 당신은 섹시하군요!\n섹시한 당신에게 추천하는 향수는...'),
  sophisticated('sophisticated', '세련됨', '오늘의 당신은 세련됐군요!\n세련된 당신에게 추천하는 향수는...'),
  sporty('sporty', '스포티함', '오늘의 당신은 스포티하군요!\n스포티한 당신에게 추천하는 향수는...');

  final String nameEN;
  final String nameKO;
  final String comment;

  const MoodType(this.nameEN, this.nameKO, this.comment);
}

class RecommendResultScreen extends ConsumerStatefulWidget {
  const RecommendResultScreen({Key? key}) : super(key: key);

  @override
  createState() => _RecommendResultScreen();
}

class _RecommendResultScreen extends ConsumerState {
  @override
  void initState() {
    // TODO: implement initState
    final recommendedPerfumeList = ref.read(recommendedPerfumeListProvider);
    ref
        .read(perfumeProvider.notifier)
        .getPerfumeDetail(recommendedPerfumeList.value!.perfumes.first.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final perfumeList = ref.watch(recommendedPerfumeListProvider);
    final favoritePerfumeList = ref.watch(favoritePerfumeListProvider);
    final perfume = ref.watch(perfumeProvider);
    final ThemeData theme = Theme.of(context);
    return OrbScaffold(
      orbAppBar: OrbAppBar(
        title: '리비의 추천 결과',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      shrinkWrap: true,
      body: perfumeList.when(
        data: (perfumeList) {
          return Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              Image.asset(
                'assets/images/${perfumeList.moods.first.name.toLowerCase()}.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                perfumeList.moods
                    .map((e) =>
                        "${MoodType.values.firstWhere((element) => element.nameEN == e.name.toLowerCase()).nameKO}(${double.parse(e.value).toStringAsFixed(1)}%)")
                    .join(', '),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,

                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                MoodType.values
                    .firstWhere((element) =>
                        element.name ==
                        perfumeList.moods.first.name.toLowerCase())
                    .comment,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff625a8b),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              perfume.when(
                data: (perfume) {
                  return Stack(
                    children: [
                      Positioned(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (!favoritePerfumeList.map((e) => e.id)
                                    .contains(perfumeList.perfumes.first.id)) {
                                  favoritePerfumeList
                                      .add(perfumeList.perfumes.first);
                                  OrbSnackBar.show(context: context, message: "즐겨찾기에 추가되었습니다.", type: OrbSnackBarType.info);

                                } else {
                                  favoritePerfumeList
                                      .remove(perfumeList.perfumes.first);
                                  OrbSnackBar.show(context: context, message: "즐겨찾기서 제거되었습니다.", type: OrbSnackBarType.info);
                                }
                              });
                            },
                            icon: favoritePerfumeList
                                .map((e) => e.id)
                                .contains(perfumeList.perfumes.first.id)
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
                      Column(
                        children: [
                          Text(
                            perfume.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: const Color(0xff625a8b),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            perfume.company,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(8),
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
                                    child: Image(
                                      image: NetworkImage(perfume.perfumeImage),
                                      width: 128,
                                      height: 128,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        NoteChartBar(notes: perfume.notes),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Color(0xffffd700),
                                                ),
                                                Text(
                                                  perfume.rating.toString(),
                                                  style: theme.textTheme.bodyMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              perfume.forGender,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "잔향:",
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              perfume.sillage,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "지속:",
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              perfume.longevity,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Column(
                            children: [
                              Text(
                                "상세설명",
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                perfume.perfumeDetail,
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => OrbShimmerContent(),
                error: (error, stackTrace) => OrbShimmerContent(),
              ),
              const SizedBox(
                height: 32,
              ),
              OrbButton(
                buttonText: '구매하기',
                enabledBackgroundColor: Color(0xff111111),
                onPressed: () async{
                  launchUrl(Uri.parse(perfume.value!.perfumeUrl));
                },
              ),
              const SizedBox(
                height: 32,
              ),
              OrbBoardContainer(
                titleText: '리비가 추천하는 다른 향수',
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          ref.read(routerProvider).pushReplacement(
                                RouteInfo.perfumeDetail.fullPath,
                                extra: perfumeList.perfumes[index + 1].id,
                              );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
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
                                  child: Image.network(
                                    perfumeList
                                        .perfumes[index + 1].thumbnailUrl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      perfumeList.perfumes[index + 1].company,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      perfumeList.perfumes[index + 1].name,
                                      style: theme.textTheme.bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          );
        },
        loading: () => OrbShimmerContent(),
        error: (error, stackTrace) => OrbShimmerContent(),
      ),
        submitButton: OrbButton(
          buttonText: '다시 추천받기',
          onPressed: () async{
            ref.read(routerProvider).pushReplacement(RouteInfo.imageRecognition.fullPath);
          },
        ),
    );
  }
}

class NoteChartBar extends StatelessWidget {
  final List<PerfumeData> notes;

  const NoteChartBar({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < (notes.length > 3 ? 3 : notes.length); i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color(i == 0 ? 0xff625a8b : i == 1 ? 0xffa8a8a8 : 0xffe5e5e5),
                width: double.parse(notes[i].value),
                height: 12,
              ),
              Text(notes[i].name),
            ],
          ),
      ],
    );
  }
}
