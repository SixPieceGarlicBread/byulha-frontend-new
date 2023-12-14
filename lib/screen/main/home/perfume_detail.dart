import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/modules/orb/components/components.dart';
import 'package:taba/screen/main/home/recommend_result_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/perfume/perfume.dart';
import '../../../domain/perfume/perfume_list_provider.dart';
import '../../../domain/perfume/perfume_provider.dart';
// 만약 다른 파일에 PerfumeDetail 클래스가 정의되어 있다면, 해당 파일을 import 해야 합니다.

class PerfumeDetailScreen extends ConsumerStatefulWidget {
  final int id;

  const PerfumeDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  createState() => _PerfumeDetailScreen();
}

class _PerfumeDetailScreen extends ConsumerState<PerfumeDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ref.read(perfumeProvider.notifier).getPerfumeDetail(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final perfumeDetail = ref.watch(perfumeProvider);
    final favoritePerfumeList = ref.watch(favoritePerfumeListProvider);

    final ThemeData theme = Theme.of(context);

    return OrbScaffold(
      shrinkWrap: true,
      body: perfumeDetail.when(
        data: (perfume) {
          return perfumeDetail.when(
            data: (perfume) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          favoritePerfumeList.map((e) => e.id).toList().contains(widget.id) ? Icons.favorite : Icons.favorite_border,
                        ),
                        onPressed: (){
                          setState(() {
                            if(!favoritePerfumeList.map((e) => e.id).toList().contains(widget.id)){
                              ref.read(favoritePerfumeListProvider).add(Perfume.fromPerfumeDetail(widget.id,perfume));
                              OrbSnackBar.show(context: context, message: "즐겨찾기에 추가되었습니다.", type: OrbSnackBarType.info);
                            }else{
                              ref.read(favoritePerfumeListProvider).removeWhere((element) => element.id == widget.id);
                              OrbSnackBar.show(context: context, message: "즐겨찾기에서 제거되었습니다.", type: OrbSnackBarType.info);

                            }
                          });
                        },
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
                                          style:
                                              theme.textTheme.bodyMedium?.copyWith(
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
                                          style:
                                              theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          perfume.sillage,
                                          style:
                                              theme.textTheme.bodyMedium?.copyWith(
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
                                          style:
                                              theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          perfume.longevity,
                                          style:
                                              theme.textTheme.bodyMedium?.copyWith(
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
          );
        },
        loading: () => OrbShimmerContent(),
        error: (error, stackTrace) => OrbShimmerContent(),
      ),
      submitButton: OrbButton(
        buttonText: '구매하기',
        onPressed: () async{
          launchUrl(Uri.parse(perfumeDetail.value!.perfumeUrl));
        },
      )
    );
  }
}

// NoteChartBar 위젯을 여기에 구현할 수 있습니다.
