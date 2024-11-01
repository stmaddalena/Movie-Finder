class Entertainment {
  final String type;
  final String title;
  final String synopsis;
  final List<String> genres;
  final String rating;
  final String score;
  final String duration;
  final String releaseDate;
  final List<Member> cast;
  final List<Member> directors;
  final List<String> productionCos;
  final String originalLanguage;
  final List<String> streaming;
  final String poster;
  final List<Reviews> reviews;

  Entertainment({
    required this.type,
    required this.title,
    required this.synopsis,
    required this.genres,
    required this.rating,
    required this.score,
    required this.duration,
    required this.releaseDate,
    required this.cast,
    required this.directors,
    required this.productionCos,
    required this.originalLanguage,
    required this.streaming,
    required this.poster,
    required this.reviews,
  });

  factory Entertainment.fromJson(Map<String, dynamic> json) {
    return Entertainment(
      type: json['type'],
      title: json['title'],
      synopsis: json['synopsis'],
      genres: List<String>.from(json['genres']),
      rating: json['rating'],
      score: json['score'],
      duration: json['duration'],
      releaseDate: json['releaseDate'],
      cast:
          (json['cast'] as List).map((item) => Member.fromJson(item)).toList(),
      directors: (json['directors'] as List)
          .map((item) => Member.fromJson(item))
          .toList(),
      productionCos: List<String>.from(json['productionCos']),
      originalLanguage: json['originalLanguage'],
      streaming: List<String>.from(json['streaming']),
      poster: json['poster'],
      reviews: (json['reviews'] as List)
          .map((item) => Reviews.fromJson(item))
          .toList(),
    );
  }
}

class Member {
  final String name;
  final String photo;

  Member({
    required this.name,
    required this.photo,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      photo: json['photo'],
    );
  }
}

class Reviews {
  final String name;
  final String review;
  final String stars;

  Reviews({
    required this.name,
    required this.review,
    required this.stars,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      name: json['name'],
      review: json['review'],
      stars: json['stars'],
    );
  }
}