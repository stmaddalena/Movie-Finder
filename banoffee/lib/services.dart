import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/entertainment.dart';
import './models/question.dart';
import './models/tmdb.dart';

class EntertainmentService {
  Future<List<Entertainment>> fetchEntertainment() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/entertainment'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Entertainment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}

class QuestionService {
  Future<List<Question>> fetchQuestion() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/questions'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}

class TMDBService {
  final String apiKey = '4c1a9513e1b5d97ed182c77304325226';
  Future<List<TMDB>> fetchUpcomingMovies() async {
    final List<TMDB> allMovies = [];
    final List<Future<List<TMDB>>> requests = List.generate(5, (index) async {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=en-EN&page=${index + 1}'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['results'];
        return jsonList.map((json) => TMDB.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    });

    final results = await Future.wait(requests);
    for (var movieList in results) {
      allMovies.addAll(movieList);
    }

    return allMovies;
  }
}
