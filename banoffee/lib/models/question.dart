class Question {
  final String id;
  final String question;
  final Map<String, List<String>> options;

  Question({
    required this.id,
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      question: json['question'] ?? 'No question provided',
      options: json['options'] != null
          ? Map<String, List<String>>.from(json['options']
              .map((key, value) => MapEntry(key, List<String>.from(value))))
          : {},
    );
  }
}
