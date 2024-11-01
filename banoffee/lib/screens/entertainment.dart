import 'package:flutter/material.dart';
import '../services.dart';
import '../models/entertainment.dart';
import '../widgets/appbar.dart';
import 'details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EntertainmentScreen(),
    );
  }
}

class EntertainmentScreen extends StatefulWidget {
  @override
  _EntertainmentScreenState createState() => _EntertainmentScreenState();
}

class _EntertainmentScreenState extends State<EntertainmentScreen> {
  late Future<List<Entertainment>> futureEntertainment;
  List<Entertainment> allEntertainment = [];
  List<Entertainment> filteredEntertainment = [];
  String searchQuery = '';
  String selectedGenre = 'All';
  String selectedStreaming = 'All';
  String? selectedType;
  String selectedSort = 'None';

  List<Map<String, String>> getCastMembers() {
    List<Map<String, String>> castMembers = [];
    Set<String> seenNames = {};

    castMembers.addAll(allEntertainment.expand((entertainment) {
      return entertainment.cast.map((member) {
        return {'name': member.name.toLowerCase(), 'photo': member.photo};
      }).where((member) => seenNames.add(member['name']!));
    }));

    castMembers.addAll(allEntertainment.expand((entertainment) {
      return entertainment.directors.map((director) {
        return {'name': director.name.toLowerCase(), 'photo': director.photo};
      }).where((director) => seenNames.add(director['name']!));
    }));

    return castMembers;
  }

  List<String> getSuggestions() {
    List<String> suggestions = [];

    suggestions
        .addAll(allEntertainment.map((entertainment) => entertainment.title));

    suggestions.addAll(allEntertainment.expand((entertainment) {
      return entertainment.productionCos.map((productionCos) => productionCos);
    }));

    suggestions.addAll(allEntertainment.expand((entertainment) {
      return entertainment.streaming.map((streaming) => streaming);
    }));

    suggestions.addAll(allEntertainment.expand((entertainment) {
      return entertainment.genres.map((genres) => genres);
    }));

    suggestions.addAll(allEntertainment
        .map((entertainment) => entertainment.originalLanguage));

    for (var entertainment in allEntertainment) {
      List<String> synopsisWords = entertainment.synopsis.split(' ');
      suggestions.addAll(synopsisWords);
    }

    for (var entertainment in allEntertainment) {
      List<String> reviewWords = entertainment.reviews
          .expand((review) => review.review.split(' '))
          .toList();
      suggestions.addAll(reviewWords);
    }

    List<String> cleanedSuggestions = suggestions
        .map((suggestion) =>
            suggestion.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase())
        .toList();

    cleanedSuggestions = cleanedSuggestions.toSet().toList();

    return cleanedSuggestions;
  }

  final List<String> genres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Drama',
    'Fantasy',
    'History',
    'Horror',
    'Musical',
    'Romance',
    'Sci-Fi',
    'Sport',
    'Thriller',
    'War'
  ];

  final List<String> streaming = [
    'Apple TV',
    'Crunchyroll',
    'HBO GO',
    'Hotstar',
    'Netflix',
    'Prime Video',
    'Viu'
  ];

  @override
  void initState() {
    super.initState();
    futureEntertainment = EntertainmentService().fetchEntertainment();
    futureEntertainment.then((entertainments) {
      setState(() {
        allEntertainment = entertainments;
        filteredEntertainment = entertainments;
        filteredEntertainment.shuffle();
      });
    });
  }

  void _filterEntertainment(String query) {
    setState(() {
      searchQuery = query;
      filteredEntertainment = allEntertainment
          .where((entertainment) =>
              (entertainment.title.toLowerCase().contains(query.toLowerCase()) ||
                  entertainment.synopsis
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(query.toLowerCase().replaceAll(' ', '')) ||
                  entertainment.genres.any((genre) => genre
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(query.toLowerCase().replaceAll(' ', ''))) ||
                  entertainment.rating
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(query.toLowerCase().replaceAll(' ', '')) ||
                  entertainment.score
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(query.toLowerCase().replaceAll(' ', '')) ||
                  entertainment.duration
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(query.toLowerCase().replaceAll(' ', '')) ||
                  entertainment.releaseDate
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(query.toLowerCase().replaceAll(' ', '')) ||
                  entertainment.productionCos.any((productionCos) =>
                      productionCos.toLowerCase().replaceAll(' ', '').contains(query.toLowerCase().replaceAll(' ', ''))) ||
                  entertainment.originalLanguage.toLowerCase().replaceAll(' ', '').contains(query.toLowerCase().replaceAll(' ', '')) ||
                  entertainment.streaming.any((streaming) => streaming.toLowerCase().replaceAll(' ', '').contains(query.toLowerCase().replaceAll(' ', ''))) ||
                  entertainment.cast.any((member) => member.name.toLowerCase().replaceAll(' ', '').contains(query.toLowerCase().replaceAll(' ', ''))) ||
                  entertainment.directors.any((member) => member.name.toLowerCase().replaceAll(' ', '').contains(query.toLowerCase().replaceAll(' ', '')))) &&
              (selectedGenre == 'All' || entertainment.genres.contains(selectedGenre)) &&
              (selectedStreaming == 'All' || entertainment.streaming.contains(selectedStreaming)) &&
              (selectedType == null || entertainment.type == selectedType))
          .toList();
      filteredEntertainment.shuffle();
    });
  }

  void _onGenreSelected(String? genre) {
    setState(() {
      selectedGenre = genre ?? 'All';
      _filterEntertainment(searchQuery);
    });
  }

  void _onStreamingSelected(String? streaming) {
    setState(() {
      selectedStreaming = streaming ?? 'All';
      _filterEntertainment(searchQuery);
    });
  }

  void _onTypeSelected(String? type) {
    setState(() {
      selectedType = type;
      _filterEntertainment(searchQuery);
    });
  }

  void _sortEntertainment(String? sortBy) {
    setState(() {
      selectedSort = sortBy ?? 'none';

      if (sortBy == 'newest') {
        filteredEntertainment.sort((a, b) {
          try {
            DateTime dateA = parseDate(a.releaseDate);
            DateTime dateB = parseDate(b.releaseDate);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });
      } else if (sortBy == 'most score') {
        filteredEntertainment.sort(
            (a, b) => double.parse(b.score).compareTo(double.parse(a.score)));
      } else if (sortBy == 'alphabet') {
        filteredEntertainment.sort((a, b) => a.title.compareTo(b.title));
      } else {
        filteredEntertainment = List.from(allEntertainment);
      }
    });
  }

  DateTime parseDate(String dateStr) {
    final match = RegExp(r'(\w{3}) (\d{1,2}), (\d{4})').firstMatch(dateStr);

    if (match != null) {
      const months = {
        'Jan': '01',
        'Feb': '02',
        'Mar': '03',
        'Apr': '04',
        'May': '05',
        'Jun': '06',
        'Jul': '07',
        'Aug': '08',
        'Sep': '09',
        'Oct': '10',
        'Nov': '11',
        'Dec': '12'
      };

      String day = match.group(2)!.padLeft(2, '0');
      String month = months[match.group(1)!] ?? '';
      String year = match.group(3)!;

      if (month.isEmpty) {
        throw FormatException('Invalid month name: ${match.group(1)}');
      }
      String formattedDate = '$year-$month-$day';
      return DateTime.parse(formattedDate);
    } else {
      throw FormatException('Invalid date format: $dateStr');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: searchQuery != ''
            ? 'SEARCH: "$searchQuery"'
            : (selectedType == null &&
                    selectedGenre == 'All' &&
                    selectedStreaming == 'All')
                ? 'ENTERTAINMENT'
                : (selectedType != null &&
                        selectedGenre == 'All' &&
                        selectedStreaming == 'All'
                    ? '$selectedType'.toUpperCase()
                    : (selectedType == null &&
                            selectedGenre != 'All' &&
                            selectedStreaming == 'All'
                        ? '$selectedGenre CONTENT'.toUpperCase()
                        : (selectedType == null &&
                                selectedGenre == 'All' &&
                                selectedStreaming != 'All'
                            ? 'WATCH AT $selectedStreaming'.toUpperCase()
                            : (selectedType != null &&
                                    selectedGenre != 'All' &&
                                    selectedStreaming == 'All'
                                ? '$selectedGenre $selectedType'.toUpperCase()
                                : (selectedType != null &&
                                        selectedGenre == 'All' &&
                                        selectedStreaming != 'All'
                                    ? '$selectedType ON $selectedStreaming'
                                        .toUpperCase()
                                    : (selectedType == null &&
                                                selectedGenre != 'All' &&
                                                selectedStreaming != 'All'
                                            ? '$selectedGenre CONTENT ON $selectedStreaming'
                                                .toUpperCase()
                                            : '$selectedGenre $selectedType ON $selectedStreaming')
                                        .toUpperCase()))))),
        searchQuery: searchQuery,
        selectedGenre: selectedGenre,
        selectedStreaming: selectedStreaming,
        selectedType: selectedType,
        genres: genres,
        streaming: streaming,
        suggestions: getSuggestions(),
        castMembers: getCastMembers(),
        onGenreSelected: _onGenreSelected,
        onStreamingSelected: _onStreamingSelected,
        onTypeSelected: _onTypeSelected,
        onSearchChanged: _filterEntertainment,
        selectedSort: selectedSort,
        onSortSelected: _sortEntertainment,
      ),
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      body: Column(
        children: [
          Expanded(
            child: filteredEntertainment.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.67,
                    ),
                    itemCount: filteredEntertainment.length,
                    itemBuilder: (context, index) {
                      Entertainment entertainment =
                          filteredEntertainment[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EntertainmentDetailsScreen(
                                  entertainment: entertainment),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.1,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(4.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Image.network(
                                    entertainment.poster,
                                    fit: BoxFit.cover, 
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
