import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/perfume/perfume_list_provider.dart';
import '../../modules/orb/components/app_bar/orb_app_bar.dart';
import '../../modules/orb/components/scaffold/orb_scaffold.dart';

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
      body: SingleChildScrollView(
        child: Column(
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
                              //
                            },
                            child: Image.network(
                              perfumeList[index].thumbnailUrl!,
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
                              perfumeList[index].company,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              perfumeList[index].name,
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
                              if(perfumeList.contains(perfumeList[index])){
                                perfumeList.remove(perfumeList[index]);
                              }else{
                                perfumeList.add(perfumeList[index]);
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
      ),
    );
  }
}
