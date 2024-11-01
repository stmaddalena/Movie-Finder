import 'package:flutter/material.dart';
import '../services.dart';
import '../models/entertainment.dart';
import '../models/question.dart';
import 'recommended.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionnaireScreen(),
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  late Future<List<Question>> futureQuestions;
  late Future<List<Entertainment>> futureEntertainment;
  int currentQuestionIndex = 0;

  Map<int, List<String>> selections = {};

  @override
  void initState() {
    super.initState();
    futureQuestions = QuestionService().fetchQuestion();
    futureEntertainment = EntertainmentService().fetchEntertainment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No questions found.',
                    style: TextStyle(color: Colors.grey[50])));
          } else {
            final questions = snapshot.data!;
            final currentQuestion = questions[currentQuestionIndex];
            return buildQuestionCard(currentQuestion, questions.length);
          }
        },
      ),
    );
  }

  Widget buildQuestionCard(Question question, int totalQuestions) {
    return Padding(
      padding: EdgeInsets.all(
        18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[50]),
                  ),
                  SizedBox(height: 20.0),
                  ...question.options.entries.map((entry) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: RadioListTile<String>(
                            title: Text(
                              entry.key,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey[50]),
                            ),
                            value: entry.value.first,
                            groupValue:
                                selections[currentQuestionIndex]?.isNotEmpty ==
                                        true
                                    ? selections[currentQuestionIndex]!.first
                                    : null,
                            activeColor: Colors.blue[200],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            onChanged: (String? value) {
                              setState(() {
                                if (value != null) {
                                  selections.putIfAbsent(
                                      currentQuestionIndex, () => []);
                                  selections[currentQuestionIndex]!.clear();
                                  selections[currentQuestionIndex]!
                                      .addAll(entry.value);
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentQuestionIndex == 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[50], fontSize: 14),
                      ),
                    ),
                  ),
                ),
              if (currentQuestionIndex > 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        shadowColor: MaterialStateProperty.all(
                            Colors.transparent),
                      ),
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex--;
                        });
                      },
                      child: Text(
                        'Previous',
                        style: TextStyle(color: Colors.grey[50], fontSize: 14),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[200],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ).copyWith(
                      splashFactory:
                          NoSplash.splashFactory, 
                      shadowColor: MaterialStateProperty.all(
                          Colors.transparent),
                    ),
                    onPressed: () {
                      bool canProceed = false;
                      canProceed =
                          selections[currentQuestionIndex]?.isNotEmpty ?? false;
                      if (canProceed) {
                        if (currentQuestionIndex < totalQuestions - 1) {
                          setState(() {
                            currentQuestionIndex++;
                          });
                        } else {
                          print(
                              'Navigating to ResultScreen with the following selections:');
                          print('Type: ${selections[0] ?? []}');
                          print('Genres: ${selections[1] ?? []}');
                          print('Rating: ${selections[2] ?? []}');
                          print('Streaming: ${selections[3] ?? []}');
                          futureEntertainment.then((entertainmentList) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendedScreen(
                                  searchQuery: '',
                                  selectedType: selections[0] ?? [],
                                  selectedGenres: selections[1] ?? [],
                                  selectedRating: selections[2] ?? [],
                                  selectedStreaming: selections[3] ?? [],
                                  entertainmentList: entertainmentList,
                                ),
                              ),
                            );
                          }).catchError((error) {
                            print('Error fetching entertainment data: $error');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error loading entertainment data.')),
                            );
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Please select an option before continuing.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            duration: Duration(milliseconds: 1864),
                          ),
                        );
                      }
                    },
                    child: Text(
                      currentQuestionIndex < totalQuestions - 1
                          ? 'Next'
                          : 'Finish',
                      style: TextStyle(
                          color: Color.fromARGB(255, 16, 16, 16), fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
