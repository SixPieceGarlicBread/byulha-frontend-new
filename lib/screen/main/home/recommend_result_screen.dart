//image_recognition_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/modules/orb/components/components.dart';

import '../../../domain/perfume/perfume_list_provider.dart';
import '../../../domain/perfume/perfume_provider.dart';

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
        .getPerfumeList(recommendedPerfumeList.value!.content.first.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final perfumeList = ref.watch(recommendedPerfumeListProvider);
    final perfume = ref.watch(perfumeProvider);
    final ThemeData theme = Theme.of(context);
    return OrbScaffold(
      orbAppBar: OrbAppBar(
        title: '추천 결과',
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
              perfume.when(
                data: (perfume) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                perfume.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
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
                                child: InkWell(
                                  onTap: () {
                                    //
                                  },
                                  child: Image(
                                    image: NetworkImage(perfume.perfumeImage),
                                    width: 128,
                                    height: 128,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xffffd700),
                                  ),
                                  Text(
                                    perfume.rating.toString(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Text(
                                perfume.forGender,
                                style: theme.textTheme.bodyMedium?.copyWith(
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
                      const SizedBox(
                        height: 32,
                      ),
                      Column(
                        children: [
                          Text("상세설명"),
                          Text("상세 설명입니다"),
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
              OrbBoardContainer(
                titleText: '추천 향수',
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
                      return Stack(
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
                                child: InkWell(
                                  onTap: () {
                                    //
                                  },
                                  child: Image.network(
                                    perfumeList.content[index + 1].thumbnailUrl,
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
                                    perfumeList.content[index + 1].company,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    perfumeList.content[index + 1].name,
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
                      );
                    }),
              ),
            ],
          );
        },
        loading: () => OrbShimmerContent(),
        error: (error, stackTrace) => OrbShimmerContent(),
      ),
    );
  }
}
