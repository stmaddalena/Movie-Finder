import 'package:flutter/material.dart';
import 'coming.dart';
import 'entertainment.dart';
import 'questionnaire.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/564x/95/05/8c/95058c2634ee3f29c899d396d36c703c.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black
                .withOpacity(0.7), 
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EntertainmentScreen()),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.0),
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/256/7525/7525602.png',
                            width: 60.0,
                            height: 60.0,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'MOVIE & SERIES',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold, 
                              color: Colors.white, 
                              shadows: [
                                Shadow(
                                  color: Colors.lightBlue
                                      .withOpacity(0.3), 
                                  offset:
                                      Offset(2.0, 2.0), 
                                  blurRadius: 4.0, 
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), 
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionnaireScreen()),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white, 
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.0),
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/256/7574/7574860.png',
                            width: 60.0,
                            height: 60.0,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'PICKER',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold, 
                              color: Colors.white, 
                              shadows: [
                                Shadow(
                                  color: Colors.lightBlue
                                      .withOpacity(0.3),
                                  offset:
                                      Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), 
                GestureDetector(
                       onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ComingScreen()),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white,
                        width: 0.5, 
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.0),
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/256/6179/6179056.png',
                            width: 60.0,
                            height: 60.0,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'MOVIE COMING',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.lightBlue
                                      .withOpacity(0.3), 
                                  offset:
                                      Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
