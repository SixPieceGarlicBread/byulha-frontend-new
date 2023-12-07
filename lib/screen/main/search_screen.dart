import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 선택된 키워드들을 관리하기 위한 상태 굉장히 중요(이해 잘 못함)
  List<bool> _selectedKeywords = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEARCH'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 검색 기능 구현
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '검색',
                  border: OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.search),
                ),
                onSubmitted: (String value) {
                  // 검색 기능 구현
                },
              ),
            ),
            Container(
              height: 100, // 분위기 선택 탭의 높이 설정
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  10, // 분위기 선택 탭의 수
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text('분위기 $index'),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Wrap(
                spacing: 8.0, // 키워드 간의 공간
                children: List.generate(
                  10, // 키워드 추천의 수
                      (index) => FilterChip(
                    label: Text('키워드 $index'),
                    selected: _selectedKeywords[index],
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedKeywords[index] = selected;
                      });
                    },
                  ),
                ),
              ),
            ),
            // 페이지 인디케이터 추가 구현 필요
          ],
        ),
      ),
    );
  }
}
