import 'package:flutter/material.dart';
import '../models/entertainment.dart';
import 'menu.dart';
import 'details.dart';

class RecommendedScreen extends StatefulWidget {
  final List<String> selectedType;
  final List<String> selectedGenres;
  final List<String> selectedRating;
  final List<String> selectedStreaming;
  final List<Entertainment> entertainmentList;
  final String searchQuery;

  RecommendedScreen({
    required this.selectedType,
    required this.selectedGenres,
    required this.selectedRating,
    required this.selectedStreaming,
    required this.entertainmentList,
    required this.searchQuery,
  });

  @override
  _RecommendedScreenState createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  late List<Entertainment> filteredEntertainmentList;

  @override
  void initState() {
    super.initState();
    filteredEntertainmentList = _filterEntertainmentList();
  }

  List<Entertainment> _filterEntertainmentList() {
    return widget.entertainmentList.where((item) {
      final typeMatch = widget.selectedType.isEmpty ||
          widget.selectedType.any((selectedType) {
            return item.type.contains(selectedType);
          });

      final genresMatch = widget.selectedGenres.isEmpty ||
          widget.selectedGenres.any((selectedGenre) {
            return item.genres.contains(selectedGenre);
          });

      final streamingMatch = widget.selectedStreaming.isEmpty ||
          widget.selectedStreaming.any((selectedService) {
            return item.streaming.contains(selectedService);
          });

      final ratingMatch = widget.selectedRating.isEmpty ||
          widget.selectedRating.any((selectedRating) {
            return item.rating.contains(selectedRating);
          });

      final searchMatch = widget.searchQuery.isEmpty ||
          item.title.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          item.cast.any((member) => member.name
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()));

      return typeMatch &&
          genresMatch &&
          ratingMatch &&
          streamingMatch &&
          searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 16, 16, 16),
        iconTheme: IconThemeData(color: Colors.grey[50]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 9.0, top: 8),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
              child: Text(
                'Finish',
                style: TextStyle(
                  color: Colors.blue[200],
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: filteredEntertainmentList.isNotEmpty
            ? ListView.builder(
                itemCount: filteredEntertainmentList.length,
                itemBuilder: (context, index) {
                  final entertainment = filteredEntertainmentList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntertainmentDetailsScreen(
                            entertainment: entertainment,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(8.0),
                      color: Color.fromARGB(255, 25, 25, 25),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              entertainment.poster,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entertainment.title,
                                  style: TextStyle(
                                    color: Colors.grey[50],
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  entertainment.genres.join(' • '),
                                  style: TextStyle(
                                    color: Colors.grey[50],
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '😢',
                      style: TextStyle(
                        fontSize: 40.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "There's nothing interesting to recommend at this time.",
                      style: TextStyle(color: Colors.grey[50]),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
