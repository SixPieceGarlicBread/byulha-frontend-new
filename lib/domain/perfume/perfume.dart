//perfume.dart

class PerfumeData {
  final String name;
  final String value;

  PerfumeData({
    required this.name,
    required this.value,
  });
}

class PerfumeDetail {
  final String name;
  final String company;
  final double rating;
  final String forGender;
  final String perfumeUrl;
  final String perfumeImage;
  final List<PerfumeData> notes;
  final String sillage;
  final String longevity;
  final String priceValue;
  final String perfumeDetail;

  //final String perfumeDetail;

  PerfumeDetail({
    required this.name,
    required this.company,
    required this.rating,
    required this.forGender,
    required this.perfumeUrl,
    required this.perfumeImage,
    required this.notes,
    required this.sillage,
    required this.longevity,
    required this.priceValue,
    required this.perfumeDetail,
  });

  factory PerfumeDetail.fromJson(Map<String, dynamic> json) {
    return PerfumeDetail(
      name: json['name'],
      company: json['company'],
      rating: json['rating'],
      forGender: json['forGender'],
      perfumeUrl: json['perfumeUrl'],
      perfumeImage: json['perfumeImage'],
      notes: (json['notes'] as List)
          .map(
            (e) => PerfumeData(
              name: e.toString().split(":")[0],
              value: e.toString().split(":")[1],
            ),
          )
          .toList(),
      sillage: json['sillage'],
      longevity: json['longevity'],
      priceValue: json['priceValue'],
      perfumeDetail: json['perfumeDetail'],
    );
  }
}

class Perfume {
  final int id;
  final String name;
  final String company;
  final double rating;
  final String forGender;
  final String thumbnailUrl;
  final List<PerfumeData>? notes;

  Perfume({
    required this.id,
    required this.name,
    required this.company,
    required this.rating,
    required this.forGender,
    required this.thumbnailUrl,
    this.notes,
  });

  factory Perfume.fromJson(Map<String, dynamic> json) {
    return Perfume(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      rating: json['rating'],
      forGender: json['forGender'],
      thumbnailUrl: json['thumbnailUrl'],
      notes: (json['notes'] as List?)
          ?.map(
            (e) => PerfumeData(
              name: e.toString().split(":")[0],
              value: e.toString().split(":")[1],
            ),
          )
          .toList(),
    );
  }

  factory Perfume.fromPerfumeDetail(int id, PerfumeDetail perfumeDetail) {
    return Perfume(
      id: id,
      name: perfumeDetail.name,
      company: perfumeDetail.company,
      rating: perfumeDetail.rating,
      forGender: perfumeDetail.forGender,
      thumbnailUrl: perfumeDetail.perfumeImage,
      notes: perfumeDetail.notes,
    );
  }
}

class PerfumeBoard {
  final List<Perfume> content;
  final bool hasNext;
  final int totalPages;
  final int totalElements;
  final int page;
  final int size;
  final bool first;
  final bool last;

  PerfumeBoard({
    required this.content,
    required this.hasNext,
    required this.totalPages,
    required this.totalElements,
    required this.page,
    required this.size,
    required this.first,
    required this.last,
  });

  factory PerfumeBoard.fromJson(Map<String, dynamic> json) {
    List<Perfume> content = [];
    for (var item in json['content']) {
      content.add(Perfume.fromJson(item));
    }
    return PerfumeBoard(
      content: content,
      hasNext: json['hasNext'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      page: json['page'],
      size: json['size'],
      first: json['first'],
      last: json['last'],
    );
  }
}

class PerfumeList {
  final List<Perfume> perfumes;
  final List<PerfumeData> moods;

  PerfumeList({
    required this.perfumes,
    required this.moods,
  });

  factory PerfumeList.fromJson(Map<String, dynamic> json) {
    List<Perfume> content = [];
    for (var item in json['perfumes']) {
      content.add(Perfume.fromJson(item));
    }
    return PerfumeList(
      perfumes: content,
      moods: (json['moods'] as List)
          .map(
            (e) => PerfumeData(
              name: e.toString().split(":")[0],
              value: e.toString().split(":")[1],
            ),
          )
          .toList(),
    );
  }
}
