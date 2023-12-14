import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/routes/router_path.dart';
import 'package:taba/routes/router_provider.dart';

import '../../domain/perfume/perfume_list_provider.dart';
import '../../domain/perfume/perfume_provider.dart';
import '../../modules/orb/components/app_bar/orb_app_bar.dart';
import '../../modules/orb/components/scaffold/orb_scaffold.dart';
import '../../modules/orb/components/snack_bar/orb_snack_bar.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  createState() => _FavoriteScreen();
}

class _FavoriteScreen extends ConsumerState<FavoriteScreen> {

  // 선택된 키워드들을 관리하기 위한 상태 굉장히 중요(이해 잘 못함)

  @override
  Widget build(BuildContext context) {
    final perfumeList = ref.watch(favoritePerfumeListProvider);
    final ThemeData theme = Theme.of(context);
    return OrbScaffold(
      orbAppBar: OrbAppBar(
        title: '찜 목록',
      ),
      shrinkWrap: true,
      body: Column(
        children: <Widget>[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: perfumeList.length,
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
                              extra: perfumeList[index].id,
                            );
                          },
                          child: Image.network(
                            perfumeList[index].thumbnailUrl,
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
                            perfumeList[index].name+"\n",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            perfumeList[index].company,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 1,
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
                            if (!perfumeList.map((e) => e.id)
                                .contains(perfumeList[index].id)) {
                              perfumeList
                                  .add(perfumeList[index]);
                              OrbSnackBar.show(context: context, message: "찜 목록에 추가되었습니다.", type: OrbSnackBarType.info);

                            } else {
                              perfumeList
                                  .remove(perfumeList[index]);
                              OrbSnackBar.show(context: context, message: "찜 목록에서 제거되었습니다.", type: OrbSnackBarType.info);
                            }
                          });
                        },
                        icon: perfumeList
                            .contains(perfumeList[index])
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
          ),
        ],
      ),
    );
  }
}
