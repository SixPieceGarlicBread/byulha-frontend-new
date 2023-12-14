import 'package:flutter/material.dart';
import 'package:taba/modules/orb/components/app_bar/orb_app_bar.dart';

import '../../modules/orb/components/scaffold/orb_scaffold.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 선택된 키워드들을 관리하기 위한 상태 굉장히 중요(이해 잘 못함)
  List<bool> _selectedKeywords = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return OrbScaffold(
      orbAppBar: OrbAppBar(
        title: '검색',
      ),
      shrinkWrap: true,
      scrollBody: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '브랜드 혹은 제품명을 입력하세요',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (String value) {
                // 검색 기능 구현
              },
            ),
          ),
          Expanded(child: Center(child: Text('검색 기능은 준비중입니다.'))),
        ],
      ),
    );
  }
}
