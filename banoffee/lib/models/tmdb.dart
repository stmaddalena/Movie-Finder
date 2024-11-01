class TMDB {
  final int id; 
  final String title; 
  final String overview; 
  final String poster; 
  final String releaseDate;
  final List<String> genres;

  TMDB({
    required this.id,
    required this.title,
    required this.overview,
    required this.poster,
    required this.releaseDate,
    required this.genres,
  });

  factory TMDB.fromJson(Map<String, dynamic> json) {
    const Map<int, String> genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      36: 'Biography',
      35: 'Comedy',
      80: 'Crime',
      18: 'Drama',
      14: 'Fantasy',
      99: 'History',
      27: 'Horror',
      10402: 'Musical',
      10749: 'Romance',
      878: 'Sci-Fi',
      10751: 'Sport',
      53: 'Thriller',
      10752: 'War'
    };

    return TMDB(
      id: json['id'],
      title: json['title'] ?? json['name'],
      overview: json['overview'],
      poster: json['poster_path'],
      releaseDate: json['release_date'] ??
          json['first_air_date'], 
      genres: List<String>.from(json['genre_ids']
          .where((genreId) => genreMap
              .containsKey(genreId))
          .map((genreId) => genreMap[genreId]!)), 
    );
  }
}
