//perfume.dart

class PerfumeNote {
  final String name;
  final String value;

  PerfumeNote({
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
  final List<PerfumeNote> notes;
  final String sillage;
  final String longevity;
  final String priceValue;
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
    //required this.perfumeDetail,
  });

  factory PerfumeDetail.fromJson(Map<String, dynamic> json) {
    return PerfumeDetail(
      name: json['name'],
      company: json['company'],
      rating: json['rating'],
      forGender: json['forGender'],
      perfumeUrl: json['perfumeUrl'],
      perfumeImage: json['perfumeImage'],
      notes: (json['notes'] as List).map((e) => PerfumeNote(
        name: e.toString().split(":")[0],
        value: e.toString().split(":")[1],
      ),).toList(),
      sillage: json['sillage'],
      longevity: json['longevity'],
      priceValue: json['priceValue'],
      //perfumeDetail: json['perfumeDetail'] ?? "상세설명 입니다.",
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

  Perfume({
    required this.id,
    required this.name,
    required this.company,
    required this.rating,
    required this.forGender,
    required this.thumbnailUrl,
  });

  factory Perfume.fromJson(Map<String, dynamic> json) {
    return Perfume(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      rating: json['rating'],
      forGender: json['forGender'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

class PerfumeList {
  final List<Perfume> content;
  final bool hasNext;
  final int totalPages;
  final int totalElements;
  final int page;
  final int size;
  final bool first;
  final bool last;

  PerfumeList({
    required this.content,
    required this.hasNext,
    required this.totalPages,
    required this.totalElements,
    required this.page,
    required this.size,
    required this.first,
    required this.last,
  });

// class PerfumeMood {
//   final int id;
//   final String name;
//   final String company;
//   final double rating;
//   final String forGender;
//   final String thumbnailUrl;
//   final String moods;
//
//   PerfumeMood ({
//     required this.id,
//     required this.name,
//     required this.company,
//     required this.rating,
//     required this.forGender,
//     required this.thumbnailUrl,
//     required this.moods,
//   });


  factory PerfumeList.fromJson(Map<String, dynamic> json) {
    List<Perfume> content = [];
    for (var item in json['content']) {
      content.add(Perfume.fromJson(item));
    }
    return PerfumeList(
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
