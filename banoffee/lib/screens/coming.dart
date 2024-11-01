import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tmdb.dart';
import '../services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ComingScreen(),
    );
  }
}

class ComingScreen extends StatefulWidget {
  @override
  _ComingScreenState createState() => _ComingScreenState();
}

class _ComingScreenState extends State<ComingScreen> {
  late Future<List<TMDB>> _tmdbList;

  @override
  void initState() {
    super.initState();
    _tmdbList = TMDBService().fetchUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[50]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Text(
          'COMING SOON',
          style: TextStyle(
              color: Colors.grey[50],
              fontSize: 19.5,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<TMDB>>(
        future: _tmdbList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<TMDB> sortedList = snapshot.data!;

          final DateTime now = DateTime.now();
          sortedList = sortedList.where((movie) {
            DateTime releaseDate = DateTime.parse(movie.releaseDate);
            return releaseDate.isAfter(now);
          }).toList();

          if (sortedList.isEmpty) {
            return Center(child: Text('No upcoming movies available'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 18.0), 
            child: ListView.builder(
              itemCount: sortedList.length,
              itemBuilder: (context, index) {
                final tmdbItem = sortedList[index];
                return Card(
                  color: Color.fromARGB(
                      255, 16, 16, 16),
                  margin: EdgeInsets.symmetric(
                      vertical: 12.0), 
                  elevation: 0, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, 
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, 
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8), 
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${tmdbItem.poster}',
                              width: double
                                  .infinity, 
                              fit: BoxFit
                                  .cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, 
                            children: [
                              SizedBox(height: 5),
                              Text(
                                tmdbItem.title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[50],
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 3),
                              Text(
                                DateFormat('MMM d, yyyy').format(
                                  DateTime.parse(tmdbItem.releaseDate),
                                ),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[50],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '${tmdbItem.genres.join(' • ')}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[50],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
